# iKuai Q6000 ImmortalWrt

为 **iKuai Q6000** 自动构建 ImmortalWrt 固件的 GitHub Actions 仓库。

> [!IMPORTANT]
> 本仓库 Q6000 默认目标为 **`ikuai_q6000` SPI-NAND 版本**，不是 `ikuai_q6000-emmc`。两种版本的 DTS、存储布局和升级流程不同，刷写前务必确认设备版本。

## 固件信息

| 项目 | 配置 |
| --- | --- |
| 设备 | iKuai Q6000 |
| SoC | MediaTek MT7986A / Filogic |
| 内存 | DTS 定义 512 MiB |
| Target | `mediatek/filogic` |
| Device | `ikuai_q6000` |
| 源码 | `dailook/immortalwrt-24.10` |
| 分支 | `openwrt-24.10` |
| 默认管理地址 | `192.168.1.1` |
| 默认密码 | 无，请首次登录后立即设置 |

上游 Q6000 DTS 将交换机端口定义为 `lan1`、`lan2`、`lan3`，独立 2.5G PHY 接口作为 `eth1`；默认网络初始化将三个 LAN 口加入 LAN，并将 `eth1` 作为 WAN。

## Q6000 两种版本

上游目前提供两个不同设备目标：

- `ikuai_q6000`：SPI-NAND 版本，本仓库默认构建目标。
- `ikuai_q6000-emmc`：eMMC bootstrap 版本，使用不同 DTS 和升级路径。

**不要仅凭设备名称互刷两个版本的 sysupgrade 固件。** 如果不能确认设备存储/启动版本，请先通过现有系统、串口启动日志或分区信息确认。

## GitHub Actions

主要工作流：

- `immortalwrt-ikuai_Q6000.yaml`：Q6000 固件构建与 Release 发布。
- `update-checker.yml`：每天检查 `dailook/immortalwrt-24.10` 的 `openwrt-24.10` 分支；发现新的上游 commit 后触发一次 Q6000 构建。
- `immortalwrt-BE12_Pro.yaml`：仓库内保留的 BE12 Pro 实验性工作流，与 Q6000 固件无关。

Q6000 workflow 同时支持在 Actions 页面手动运行。SSH/tmate 调试仅在手动运行并明确选择 `enable_ssh_debug=true` 时启用，普通构建失败不会自动开放远程调试会话。

### 发布版本

每次成功构建使用独立 Release tag：

```text
ikuai-q6000-24.10-YYYYMMDD-<upstream-short-sha>
```

这样可以从 Release tag 直接定位构建日期和上游源码版本，避免不断覆盖同一个 Release。

Release 中通常包含：

- `*-squashfs-sysupgrade.bin`：正常系统升级使用。
- `*-initramfs-kernel.bin`：内存启动/恢复等场景使用；不要把它当普通 sysupgrade 固件。
- `*.manifest`：固件软件包清单。
- `sha256sums`：文件完整性校验。
- `build.config`：该次构建最终使用的完整配置。
- `Packages.tar.gz`：构建产生的软件包归档（存在时）。

## 手动构建

1. 打开仓库的 **Actions** 页面。
2. 选择 **immortalwrt-ikuai_Q6000**。
3. 点击 **Run workflow**。
4. 正常情况下保持 `enable_ssh_debug=false`。
5. 等待编译完成后从 **Releases** 下载固件。

## 刷写与升级

已经运行兼容 ImmortalWrt/OpenWrt 的 Q6000，通常应使用文件名包含：

```text
ikuai_q6000-squashfs-sysupgrade.bin
```

的固件进行 sysupgrade。

升级前建议：

1. 确认当前设备是本仓库对应的 `ikuai_q6000` SPI-NAND 版本。
2. 备份重要配置。
3. 校验下载文件的 SHA256。
4. 跨来源、跨较大版本升级时优先考虑不保留配置，避免旧 UCI 配置造成兼容问题。
5. 不要对型号、存储布局或镜像兼容性不确定的设备使用 `sysupgrade -F` 强制刷写。

> [!WARNING]
> 刷机始终存在无法启动、配置丢失或需要串口/Bootloader 恢复的风险。本仓库只负责自动构建固件，不改变上游设备兼容性判断。

## 默认安全策略

仓库的 `scripts/init-settings.sh` 不再修改 ImmortalWrt/OpenWrt 默认 WAN 防火墙策略，也不会全局关闭 dnsmasq DNS Rebind Protection。

如果确有特殊拓扑需求，例如 Q6000 永远处于可信上级 LAN 后方，应在设备部署后按实际网络环境单独配置，而不是把 `WAN input=ACCEPT` 等策略写死进公共固件。

## 自定义配置

当前 Q6000 使用 `ikuai-q6000.config`。它来自完整的 OpenWrt/ImmortalWrt `.config`，包含较多 Kconfig 自动生成项。

长期维护更推荐使用对应源码重新生成精简配置：

```bash
cp ikuai-q6000.config .config
make defconfig
./scripts/diffconfig.sh > ikuai-q6000.config.new
```

确认目标设备、插件和关键功能无变化后，再用精简配置替换旧文件。不要直接通过文本批量删除现有配置项，因为 Kconfig 存在依赖和隐式选择关系。

当前配置还启用了 initramfs、kernel debug/debug info 等选项。如果只需要日常 sysupgrade，可以在本地 `make menuconfig` 验证后进一步精简；如果需要内存启动、恢复或驱动调试，则应保留相应功能。

## 构建流程

Q6000 workflow 的主要步骤：

1. 初始化 Ubuntu 构建环境并释放磁盘空间。
2. shallow clone 上游 `openwrt-24.10` 分支。
3. 导入 `ikuai-q6000.config` 并执行 `make defconfig`。
4. 更新并安装 feeds。
5. 加载仓库自定义脚本。
6. 缓存下载目录并下载源码包。
7. 多线程编译；失败后使用 `make -j1 V=s` 输出详细错误。
8. 从确定的 `bin/targets/mediatek/filogic` 目录整理产物。
9. 提取 manifest 中的内核版本并创建带日期和源码 SHA 的 Release。

## 目录说明

```text
.
├── .github/workflows/
│   ├── immortalwrt-ikuai_Q6000.yaml
│   ├── immortalwrt-BE12_Pro.yaml
│   └── update-checker.yml
├── scripts/
│   └── init-settings.sh
├── ikuai-q6000.config
├── OpenWrt-part1.sh
└── OpenWrt-part2.sh
```

## 上游与致谢

本仓库的 Q6000 固件基于以下项目及生态：

- ImmortalWrt / OpenWrt
- `dailook/immortalwrt-24.10`
- GitHub Actions
- P3TERX Actions-OpenWrt 项目提供的自动构建思路

设备支持、内核、驱动和基础软件包主要来自上游源码；本仓库侧重 Q6000 的构建配置、自动化和发布。

## License

仓库中继承自其他项目的文件遵循其原有许可证；新增或修改内容请同时遵守对应上游项目的许可证要求。
