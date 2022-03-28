@echo off

title GIT one key commit
color 3
echo Current directory %cd%
echo;

echo Operation: git add .
git add .
echo;

set /p declation= please input commit msg:
git commit -m "%declation%"
echo;

rem set /p current_branch= Which branch do you wanna push?: git push origin master? or develop?:
git push origin develop
echo;
