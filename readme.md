
# SSH Helper 脚本使用说明

此仓库包含一组用于简化 SSH 操作的脚本工具，主要用于生成 SSH 密钥对、将公钥复制到远程服务器、测试 SSH 连接等常见的 SSH 管理任务。

## 目录

- [安装](#安装)
- [脚本使用](#脚本使用)
  - [generate](#生成-ssh-密钥)
  - [show](#查看-ssh-密钥)
  - [show-path](#查看-ssh-密钥路径)
  - [copy](#将公钥复制到服务器)
  - [connect](#连接到远程服务器)
  - [test](#测试-ssh-连接)
  - [config](#配置-ssh-客户端)
  - [list](#列出已知主机)
  - [help](#查看帮助)
- [配置](#配置)
  - [设置 PATH 以便快速使用](#设置-path-以便快速使用)
- [常见问题](#常见问题)
- [贡献](#贡献)
- [许可证](#许可证)

## 安装

1. 克隆或下载该仓库到本地机器

```bash
git clone https://github.com/your_username/ssh-helper-scripts.git
cd ssh-helper-scripts
```

2. **对于 Linux/macOS**：确保已经安装了 `ssh` 和 `ssh-copy-id` 工具。大多数 Linux 系统已经安装了这些工具，如果没有，请使用以下命令安装:

   - **Ubuntu/Debian**:
   ```bash
   sudo apt-get install openssh-client
   ```

   - **CentOS/RHEL**:
   ```bash
   sudo yum install openssh-clients
   ```

   - **macOS**：macOS 默认安装了 `ssh` 和 `ssh-copy-id`，无需额外安装。

3. **对于 Windows**：确保已经安装了 `Git for Windows` 或 PowerShell。

4. **使脚本可执行（仅限 Linux/macOS）**:
```bash
chmod +x ssh-helper.sh
```

## 脚本使用

### `generate` - 生成 SSH 密钥

此命令用于生成一个新的 SSH 密钥对（私钥和公钥）。如果密钥对已存在，它将跳过生成过程。

```bash
./ssh-helper.sh generate
```

### `show` - 查看 SSH 密钥

显示当前生成的 SSH 私钥和公钥的内容。

```bash
./ssh-helper.sh show
```

### `show-path` - 查看 SSH 密钥路径

显示当前配置的 SSH 私钥和公钥路径。

```bash
./ssh-helper.sh show-path
```

### `copy` - 将公钥复制到服务器

此命令将本地公钥（`id_rsa.pub`）复制到远程服务器的 `~/.ssh/authorized_keys` 文件中，允许使用公钥登录。

```bash
./ssh-helper.sh copy
```

执行时会提示你输入远程服务器的用户名和 IP 地址。

### `connect` - 连接到远程服务器

此命令使用生成的私钥连接到远程服务器。

```bash
./ssh-helper.sh connect
```

执行时会提示你输入远程服务器的用户名和 IP 地址。

### `test` - 测试 SSH 连接

此命令用于测试是否能成功通过 SSH 连接到远程服务器。

```bash
./ssh-helper.sh test
```

### `config` - 配置 SSH 客户端

此命令帮助你设置 SSH 客户端的配置文件（`~/.ssh/config`）。该文件可以用来配置默认的 SSH 用户名、端口等选项。

```bash
./ssh-helper.sh config
```

### `list` - 列出已知主机

此命令显示 `~/.ssh/known_hosts` 文件的内容，列出所有已知的远程服务器。

```bash
./ssh-helper.sh list
```

### `help` - 查看帮助

显示所有可用命令的帮助信息。

```bash
./ssh-helper.sh help
```

## 配置

### 设置 PATH 以便快速使用

为了方便快捷地在任何地方运行脚本，你可以将脚本所在目录添加到系统的 `PATH` 环境变量中。

#### **Linux/macOS**：

1. 打开终端并编辑你的 shell 配置文件（例如 `~/.bashrc` 或 `~/.zshrc`）：

```bash
nano ~/.bashrc   # 或者 ~/.zshrc
```

2. 在文件末尾添加以下行：

```bash
export PATH=$PATH:/path/to/your/scripts
```

将 `/path/to/your/scripts` 替换为脚本所在的实际路径。

3. 保存并退出后，运行以下命令使配置生效：

```bash
source ~/.bashrc   # 或者 source ~/.zshrc
```

#### **Windows**：

1. 打开 **系统属性** 并进入 **高级系统设置**。
2. 点击 **环境变量**。
3. 在 **系统变量** 部分，找到 `Path` 变量并点击 **编辑**。
4. 添加脚本文件夹的路径（例如 `C:\path	o\your\scripts`）。
5. 保存并关闭，然后重新启动命令提示符或 PowerShell。

## 常见问题

### 如何重新生成 SSH 密钥对？

如果你需要重新生成 SSH 密钥对，可以先删除现有的密钥文件，然后再次运行 `generate` 命令：

```bash
rm ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
./ssh-helper.sh generate
```

### 如何将公钥添加到多个服务器？

你可以运行 `copy` 命令，将公钥复制到多个服务器。每次输入不同的远程服务器信息，脚本会自动处理公钥复制操作。

### 为什么复制公钥后仍然要求输入密码？

- 确保公钥已正确添加到远程服务器的 `~/.ssh/authorized_keys` 文件中。
- 确保远程服务器的 `sshd_config` 配置文件允许使用公钥认证，并且配置项 `PubkeyAuthentication` 设置为 `yes`。
- 确保 `~/.ssh` 目录和 `authorized_keys` 文件的权限正确：`chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys`。

## 贡献

欢迎提交问题（issue）和合并请求（pull request）。如果你有改进建议或新功能，欢迎向项目贡献。

## 许可证

本项目采用 MIT 许可证，详情请查看 [LICENSE](LICENSE) 文件。
