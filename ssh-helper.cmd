@echo off
:: ���� SSH ��Կ·�� (Windows �ϵ�·��)
set KEY_PATH=C:/Users/yonga/.ssh/id_rsa
set PUB_KEY_PATH=%KEY_PATH%.pub

:: ��������
if "%1"=="" goto :help
if "%1"=="help" goto :help
goto :check_other_commands

:help
echo �������
echo    generate  - ���� SSH ˽Կ�͹�Կ
echo    show      - ��ʾ��ǰ˽Կ�͹�Կ����
echo    show-path - ��ʾ��ǰ˽Կ�͹�Կ��·��
echo    copy      - ����Կ���Ƶ�Զ�̷�����
echo    connect   - ʹ�� SSH ���ӵ�Զ�̷�����
echo    test      - ���� SSH �����Ƿ�ɹ�
echo    config    - ���� SSH �ͻ�������
echo    list      - �г���֪����
echo    help      - ��ʾ����
goto :eof

:check_other_commands

:: ��ʾ��ǰ˽Կ�͹�Կ��·��
if "%1"=="show-path" (
    echo ��ǰ˽Կ·����%KEY_PATH%
    echo ��ǰ��Կ·����%PUB_KEY_PATH%
    goto :eof
)

:: ���� SSH ��Կ
if "%1"=="generate" (
    echo �������� SSH ˽Կ�͹�Կ...
    if not exist "%KEY_PATH%" (
        ssh-keygen -t rsa -b 4096 -f "%KEY_PATH%" -N ""
        echo ��Կ��������ɣ�%KEY_PATH% �� %PUB_KEY_PATH%
    ) else (
        echo ˽Կ�Ѵ��ڣ�%KEY_PATH%���������ɲ��衣
    )
    goto :eof
)

:: ��ʾ��ǰ˽Կ�͹�Կ����
if "%1"=="show" (
    echo ��ʾ��ǰ��˽Կ�͹�Կ���ݣ�
    if exist "%KEY_PATH%" (
        echo ˽Կ���ݣ�
        type "%KEY_PATH%"
        echo.
    ) else (
        echo ˽Կ�ļ������ڡ�
    )
    if exist "%PUB_KEY_PATH%" (
        echo ��Կ���ݣ�
        type "%PUB_KEY_PATH%"
        echo.
    ) else (
        echo ��Կ�ļ������ڡ�
    )
    goto :eof
)

:: ����Կ���Ƶ�Զ�̷�����
if "%1"=="copy" (
    set /p REMOTE_USER=������Զ�̷������û���: 
    set /p REMOTE_SERVER=������Զ�̷�����IP��ַ: 
    echo ���ڽ���Կ���Ƶ�Զ�̷����� %REMOTE_SERVER% ��...
    ssh-copy-id -i "%PUB_KEY_PATH%" %REMOTE_USER%@%REMOTE_SERVER%
    if %ERRORLEVEL% EQU 0 (
        echo ��Կ�ɹ����Ƶ������� %REMOTE_SERVER%��
    ) else (
        echo ��Կ����ʧ�ܡ������û����ͷ��������ӡ�
    )
    goto :eof
)

:: ʹ�� SSH ���ӵ�Զ�̷�����
if "%1"=="connect" (
    set /p REMOTE_USER=������Զ�̷������û���: 
    set /p REMOTE_SERVER=������Զ�̷�����IP��ַ: 
    echo ����ʹ�� SSH ���ӵ� %REMOTE_SERVER%...
    ssh -i "%KEY_PATH%" %REMOTE_USER%@%REMOTE_SERVER%
    goto :eof
)

:: ���� SSH �����Ƿ�ɹ�
if "%1"=="test" (
    set /p REMOTE_USER=������Զ�̷������û���: 
    set /p REMOTE_SERVER=������Զ�̷�����IP��ַ: 
    echo ���ڲ����� %REMOTE_SERVER% �� SSH ����...
    ssh -o BatchMode=yes -o ConnectTimeout=5 %REMOTE_USER%@%REMOTE_SERVER% exit
    if %ERRORLEVEL% EQU 0 (
        echo SSH ���ӳɹ���
    ) else (
        echo SSH ����ʧ�ܣ������������û������״̬��
    )
    goto :eof
)

:: ���� SSH �ͻ�������
if "%1"=="config" (
    echo ���� SSH �ͻ�������...
    echo �����������Ĭ�ϵ� SSH �˿ڡ��û��������ã����޸������ļ��е����ã�
    echo %USERPROFILE%\.ssh\config
    echo ����ʹ������������б༭��
    echo notepad %USERPROFILE%\.ssh\config
    goto :eof
)

:: �г���֪����
if "%1"=="list" (
    echo �г���֪�� SSH ������
    echo -----------------------------------
    type "%USERPROFILE%\.ssh\known_hosts"
    echo -----------------------------------
    goto :eof
)

echo ����δ֪���� "%1"��
echo ʹ�� "ssh-helper help" �鿴���������
goto :eof
