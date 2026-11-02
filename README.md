# TokenEconomizer 一键安装指南

> 第三方部署指南 · 非 TokenEconomizer 官方仓库。官方项目：[microsoft/TokenEconomizer](https://github.com/microsoft/TokenEconomizer)
> 内容来自官方文档（2026-11-02）。项目迭代快，请以[官方文档](https://github.com/microsoft/TokenEconomizer#quick-start)为准。

[![⚡ 一键安装](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键安装推荐用百度搭子)

## 一键安装（推荐：用百度搭子）

> [!TIP]
> 不用自己敲命令，让百度搭子帮你把环境跑起来。

⚠️ 需要 Python 3.10+，以及一个已登录的 Claude Code、Codex、Copilot CLI 或 opencode。插件从克隆目录运行，装完不能删仓库。对 agent 版本有窗口限制：Claude Code 2.1.300–2.1.310、Codex 0.153.1–0.164.0、Copilot CLI 1.0.83–1.0.102；Cursor 只是实验支持且仅 macOS/Linux，Windows 用不了。它不需要自己的 Key，学习数据留在 `~/.tokeneconomizer`。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/tokeneconomizer-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会克隆仓库并把它注册成 agent 插件，再跑一次状态检查确认生效，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## TokenEconomizer 是什么？

TokenEconomizer 是开源的不改你的 agent，也不碰密钥，只在旁边记下每次会话花了多少（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/microsoft/TokenEconomizer?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

在 coding agent 旁边做黑盒成本控制：通过插件钩子记录每次会话的 token 与花费，分析哪些工具调用在浪费上下文，并给出可执行的裁剪建议，不拦截也不改写你的请求。

- 零侵入：不改 agent 源码，不接管模型调用
- 本地学习：统计与结论留在自己机器
- 多客户端：Claude Code、Codex、Copilot、opencode
- 工具裁剪建议：找出反复浪费上下文的调用
- 会话成本报告：按项目与时间看开销
- Apache-2.0，微软开源

（来源：[官方仓库](https://github.com/microsoft/TokenEconomizer)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 4323 stars | 名称搜索仅 9 条结果 |
| 微软开源 | Apache-2.0 |
| 不改 agent、不碰密钥 | — |
| 给出具体的工具裁剪建议 | — |
| 统计保存在本机 | — |
| 多客户端覆盖主流 agent | — |

| 需要注意 | 说明 |
|---|---|
| 对 agent 版本窗口要求很窄 | — |
| Cursor 支持仍是实验且限 macOS/Linux | — |
| 仓库必须保留在原位 | — |
| 只做统计与建议 | 不直接省钱 |
| 项目很新 | 钩子行为可能变 |

> 以上基于官方文档与社区反馈整理（2026-11-02），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/microsoft/TokenEconomizer.git
cd TokenEconomizer
claude plugin marketplace add "$PWD"
claude plugin install tokeneconomizer@tokeneconomizer
echo "装好后在 Claude Code 里运行 /tokeneconomizer:status"
```

部署步骤来源：[https://github.com/microsoft/TokenEconomizer#quick-start](https://github.com/microsoft/TokenEconomizer#quick-start)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Python 3.10+、四类客户端与版本窗口 | 已核对 2026-11-02 |
| 确认插件从克隆目录运行、数据在 ~/.tokeneconomizer | 已核对 2026-11-02 |
| 未实测安装与统计 | 说明 2026-11-02 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-02 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-02 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；本仓库的 MCP 只提供安装步骤、版本要求与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-02）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\tokeneconomizer-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 支持的客户端

| 客户端 | 版本窗口 | 备注 |
|---|---|---|
| Claude Code | 2.1.300–2.1.310 | 完整支持 |
| Codex | 0.153.1–0.164.0 | 需要在 Hooks 提示里选信任 |
| Copilot CLI | 1.0.83–1.0.102 | 完整支持 |
| Cursor Agent | 3.24.9 | 实验，仅 macOS/Linux |
| opencode | 实验 | 未全面测试 |

## 安装要点

- 插件从克隆目录运行，**仓库不能删也不能挪**
- 每个客户端第一次启动要信任目录与钩子
- 装完先跑状态命令，再按提示刷新一次工具目录
- 升级 agent 后要重新刷新目录

## 数据在哪

统计与学习结果写在 `~/.tokeneconomizer`。不需要配置 API Key，也不会上传你的提示词。

## 注意

- 版本窗口很窄，升级 agent 后可能暂时不兼容
- Cursor 在 Windows 上不支持
- 它是旁路统计，不会替你减少 token，只是告诉你哪里浪费
- 卸载时记得同时移除插件与本地数据目录
- Apache-2.0，可自用可二开

## 常见坑

- 状态命令报错：确认 Python 3.10+ 在 PATH，且已信任插件脚本
- 钩子不生效：在 agent 的信任提示里选择允许，然后重启会话
- Codex 没反应：从下一个会话才生效，先退出再进
- 升级后失效：重新跑一次工具目录刷新
- Cursor 装不上：Windows 不支持，换 macOS/Linux
- 数据对不上：只统计钩子能看到的调用，部分客户端成本显示不可用
- 删了仓库后插件坏掉：重新克隆并重新注册

## 免责声明

本仓库为第三方指南，与 TokenEconomizer 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-02），项目迭代快，请以[官方文档](https://github.com/microsoft/TokenEconomizer#quick-start)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
