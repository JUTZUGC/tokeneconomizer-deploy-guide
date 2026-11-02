#!/usr/bin/env bash
set -euo pipefail
# TokenEconomizer 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/microsoft/TokenEconomizer#quick-start
# 更新日期：2026-11-02
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/microsoft/TokenEconomizer.git
cd TokenEconomizer
claude plugin marketplace add "$PWD"
claude plugin install tokeneconomizer@tokeneconomizer
echo "装好后在 Claude Code 里运行 /tokeneconomizer:status"

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/microsoft/TokenEconomizer#quick-start"
