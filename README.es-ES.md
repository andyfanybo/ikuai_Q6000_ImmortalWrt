

**Español** | [中文](https://p3terx.com/archives/build-openwrt-with-github-actions.html)

# Actions-OpenWrt

[![LICENSE](https://img.shields.io/github/license/mashape/apistatus.svg?style=flat-square&label=LICENSE)](https://github.com/P3TERX/Actions-OpenWrt/blob/master/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/P3TERX/Actions-OpenWrt.svg?style=flat-square&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/P3TERX/Actions-OpenWrt.svg?style=flat-square&label=Forks&logo=github)

Una plantilla para compilar OpenWrt con GitHub Actions

## Uso

- Haz clic en el botón [Use this template](https://github.com/P3TERX/Actions-OpenWrt/generate) para crear un nuevo repositorio.
- Genera los archivos `.config` utilizando el código fuente de [Lean's OpenWrt](https://github.com/coolsnowwolf/lede). (Puedes cambiarlo a través de variables de entorno en el archivo de flujo de trabajo.)
- Sube el archivo `.config` al repositorio de GitHub.
- Selecciona `Build OpenWrt` en la página de Actions.
- Haz clic en el botón `Run workflow`.
- Cuando la compilación esté completa, haz clic en el botón `Artifacts` en la esquina superior derecha de la página de Actions para descargar los binarios.

## Consejos

- Puede llevar mucho tiempo crear un archivo `.config` y compilar el firmware de OpenWrt. Por lo tanto, antes de crear un repositorio para compilar tu propio firmware, puedes verificar si otros ya lo han compilado y cumple con tus necesidades simplemente [buscando `Actions-Openwrt` en GitHub](https://github.com/search?q=Actions-openwrt).
- Agrega alguna información meta de tu firmware compilado (como la arquitectura del firmware y los paquetes instalados) a la descripción de tu repositorio, esto le ahorrará tiempo a otros.

## Créditos

- [Microsoft Azure](https://azure.microsoft.com)
- [GitHub Actions](https://github.com/features/actions)
- [OpenWrt](https://github.com/openwrt/openwrt)
- [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
- [Mikubill/transfer](https://github.com/Mikubill/transfer)
- [softprops/action-gh-release](https://github.com/softprops/action-gh-release)
- [Mattraks/delete-workflow-runs](https://github.com/Mattraks/delete-workflow-runs)
- [dev-drprasad/delete-older-releases](https://github.com/dev-drprasad/delete-older-releases)
- [peter-evans/repository-dispatch](https://github.com/peter-evans/repository-dispatch)

## Licencia

[MIT](https://github.com/P3TERX/Actions-OpenWrt/blob/main/LICENSE) © [**P3TERX**](https://p3terx.com)
