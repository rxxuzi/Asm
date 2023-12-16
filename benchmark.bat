@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM 実行コマンドの設定
SET "runCommand=.\run\add.exe"

REM 日付と時刻の取得とフォーマットの変更
FOR /F "tokens=2 delims==" %%I IN ('wmic os get localdatetime /value') DO SET datetime=%%I
SET "FormattedDate=%datetime:~0,4%/%datetime:~4,2%/%datetime:~6,2%"
SET "FormattedTime=%datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%"
echo Current Date: %FormattedDate%
echo Current Time: %FormattedTime%

REM フォルダの準備
echo Checking if %runCommand% exists...
IF NOT EXIST %runCommand% (
    echo %runCommand% not found.
    IF NOT EXIST .\log (
        echo Creating log directory...
        MKDIR .\log
    )
    echo Writing error log...
    echo Error: %runCommand% not found > .\log\error-%datetime:~0,8%-by-batch.log
    exit /b
)

echo Preparing benchmark directory...
IF NOT EXIST .\benchmark (
    MKDIR .\benchmark
)

SET "ResultFile=.\benchmark\results-%datetime:~0,8%.txt"
echo Creating result file: %ResultFile%

> "%ResultFile%" echo Date, Time, Run Number, Execution Time (ms)

REM ベンチマークの実行
SET "TotalTime=0"
echo Starting benchmark...
FOR /L %%I IN (1,1,20) DO (
    echo Running %runCommand%, iteration %%I...
    REM 実行時間の測定
    FOR /F "tokens=*" %%A IN ('PowerShell -Command "(Measure-Command { %runCommand% }).TotalMilliseconds"') DO (
        SET "ExecTime=%%A"
    )

    REM 結果の記録
    echo Recording results for iteration %%I...
    echo %FormattedDate%, %FormattedTime%, %%I, !ExecTime! >> "%ResultFile%"

    REM 合計値の更新
    SET /A "TotalTime+=ExecTime"
)

REM 平均値の計算と記録
echo Calculating averages...
SET /A "AverageTime100=TotalTime * 100"
SET /A "AverageTime=AverageTime100 / 20"
SET /A "AverageTimeDecimal=AverageTime %% 100"
IF "%AverageTimeDecimal%" LSS "10" (SET "AverageTimeDecimal=0%AverageTimeDecimal%")
SET /A "AverageTime/=100"
echo Recording average...
echo Average Execution Time (ms) :  %AverageTime%.%AverageTimeDecimal% >> "%ResultFile%"
echo %runCommand% >> "%ResultFile%"
echo Benchmark completed.

ENDLOCAL



