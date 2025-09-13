# Setup WSL in Windows 11

1. 用系統管理者開啟powershell
2. 安裝wsl,預設安裝ubuntu24.04
   `wsl --install`
   ![image](https://hackmd.io/_uploads/SkDWhIzill.png)
   ![image](https://hackmd.io/_uploads/ByqfnIGogl.png)
   確認有無安裝ubuntu 
   `wsl --list`
   ![image](https://hackmd.io/_uploads/Bk_4pUfixe.png)

3. 進入ubuntu wsl
    `wsl -d ubuntu`
4. 關閉ubuntu wsl
   `wsl --shutdown`
5. 設定CPU核心數量與記憶體容量by WSL Settings
   ![image](https://hackmd.io/_uploads/Bk7eTLMsel.png)
   ![image](https://hackmd.io/_uploads/SkoFJDzoxx.png)
6. 設定硬碟vhd容量100GB，設定前先關閉wsl
   `wsl --manage ubuntu --resize 100GB`
   進入ubuntu wsl 
   `wsl -d ubuntu`
   ![image](https://hackmd.io/_uploads/ry27lvMoxx.png)

其他功能, 移除ubuntu wsl
設定>應用程式>已安裝的應用程式
![image](https://hackmd.io/_uploads/HyHkWDfigg.png)
確認移除
`wsl --list`
![image](https://hackmd.io/_uploads/rJ0VWPfixg.png)
