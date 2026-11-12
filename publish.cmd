@echo off
rem 一键发布《盐线：度假岛·船厂》到你的 GitHub
rem 首次运行会弹出 GitHub 登录授权窗口（浏览器），按提示登录一次即可
chcp 65001 >nul
cd /d "%~dp0"
echo === 提交本地改动 ===
git add -A
git commit -m "盐线：度假岛·船厂 — 场景重塑版（全程序化生成，全中文）" || echo (没有新改动)
echo === 创建远程仓库并推送 ===
git push -u origin main
if errorlevel 1 (
  echo.
  echo 推送失败：多半是远程仓库还不存在，或凭据授权被取消。
  echo 请到 https://github.com/new 手动创建空仓库 saltline-resort-island 后重新运行本脚本，
  echo 或在弹出的授权窗口完成登录。
  pause
  exit /b 1
)
echo.
echo 完成！仓库: https://github.com/yuyang2230/saltline-resort-island
echo 开启 Pages: 仓库 Settings -^> Pages -^> Branch 选 main -^> Save
pause
