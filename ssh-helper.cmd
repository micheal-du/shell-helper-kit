@echo off
:: 设置 SSH 密钥路径 (Windows 上的路径)
set KEY_PATH=C:/Users/yonga/.ssh/id_rsa
set PUB_KEY_PATH=%KEY_PATH%.pub

:: 帮助功能
if "%1"=="" goto :help
if "%1"=="help" goto :help
goto :check_other_commands

:help
echo 可用命令：
echo    generate  - 生成 SSH 私钥和公钥
echo    show      - 显示当前私钥和公钥内容
echo    show-path - 显示当前私钥和公钥的路径
echo    copy      - 将公钥复制到远程服务器
echo    connect   - 使用 SSH 连接到远程服务器
echo    test      - 测试 SSH 连接是否成功
echo    config    - 配置 SSH 客户端设置
echo    list      - 列出已知主机
echo    help      - 显示帮助
goto :eof

:check_other_commands

:: 显示当前私钥和公钥的路径
if "%1"=="show-path" (
    echo 当前私钥路径：%KEY_PATH%
    echo 当前公钥路径：%PUB_KEY_PATH%
    goto :eof
)

:: 生成 SSH 密钥
if "%1"=="generate" (
    echo 正在生成 SSH 私钥和公钥...
    if not exist "%KEY_PATH%" (
        ssh-keygen -t rsa -b 4096 -f "%KEY_PATH%" -N ""
        echo 密钥对生成完成：%KEY_PATH% 和 %PUB_KEY_PATH%
    ) else (
        echo 私钥已存在：%KEY_PATH%，跳过生成步骤。
    )
    goto :eof
)

:: 显示当前私钥和公钥内容
if "%1"=="show" (
    echo 显示当前的私钥和公钥内容：
    if exist "%KEY_PATH%" (
        echo 私钥内容：
        type "%KEY_PATH%"
        echo.
    ) else (
        echo 私钥文件不存在。
    )
    if exist "%PUB_KEY_PATH%" (
        echo 公钥内容：
        type "%PUB_KEY_PATH%"
        echo.
    ) else (
        echo 公钥文件不存在。
    )
    goto :eof
)

:: 将公钥复制到远程服务器
if "%1"=="copy" (
    set /p REMOTE_USER=请输入远程服务器用户名: 
    set /p REMOTE_SERVER=请输入远程服务器IP地址: 
    echo 正在将公钥复制到远程服务器 %REMOTE_SERVER% 上...
    ssh-copy-id -i "%PUB_KEY_PATH%" %REMOTE_USER%@%REMOTE_SERVER%
    if %ERRORLEVEL% EQU 0 (
        echo 公钥成功复制到服务器 %REMOTE_SERVER%。
    ) else (
        echo 公钥复制失败。请检查用户名和服务器连接。
    )
    goto :eof
)

:: 使用 SSH 连接到远程服务器
if "%1"=="connect" (
    set /p REMOTE_USER=请输入远程服务器用户名: 
    set /p REMOTE_SERVER=请输入远程服务器IP地址: 
    echo 正在使用 SSH 连接到 %REMOTE_SERVER%...
    ssh -i "%KEY_PATH%" %REMOTE_USER%@%REMOTE_SERVER%
    goto :eof
)

:: 测试 SSH 连接是否成功
if "%1"=="test" (
    set /p REMOTE_USER=请输入远程服务器用户名: 
    set /p REMOTE_SERVER=请输入远程服务器IP地址: 
    echo 正在测试与 %REMOTE_SERVER% 的 SSH 连接...
    ssh -o BatchMode=yes -o ConnectTimeout=5 %REMOTE_USER%@%REMOTE_SERVER% exit
    if %ERRORLEVEL% EQU 0 (
        echo SSH 连接成功！
    ) else (
        echo SSH 连接失败，请检查连接设置或服务器状态。
    )
    goto :eof
)

:: 配置 SSH 客户端设置
if "%1"=="config" (
    echo 配置 SSH 客户端设置...
    echo 如果你想设置默认的 SSH 端口、用户名等配置，请修改以下文件中的设置：
    echo %USERPROFILE%\.ssh\config
    echo 可以使用以下命令进行编辑：
    echo notepad %USERPROFILE%\.ssh\config
    goto :eof
)

:: 列出已知主机
if "%1"=="list" (
    echo 列出已知的 SSH 主机：
    echo -----------------------------------
    type "%USERPROFILE%\.ssh\known_hosts"
    echo -----------------------------------
    goto :eof
)

echo 错误：未知命令 "%1"。
echo 使用 "ssh-helper help" 查看命令帮助。
goto :eof
