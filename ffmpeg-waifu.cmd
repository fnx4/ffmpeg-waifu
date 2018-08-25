@echo off
if not exist waifu2x-caffe-cui.exe echo waifu2x-caffe-cui.exe not found & pause & exit
if not exist ffmpeg.exe echo ffmpeg.exe not found & pause & exit
mkdir files
mkdir files\input_video
mkdir files\temp_audio
mkdir files\output_video
mkdir files\png_frames_default
mkdir files\png_frames_upscaled
echo copy your input.mkv or input.mp4 to files\input_video & pause
set n=err
if exist files\input_video\input.mp4 set n=input.mp4 & set e=mp4
if exist files\input_video\input.mkv set n=input.mkv & set e=mkv
if %n%==err echo input.mp4 or input.mkv not found & pause & exit
ffmpeg.exe -i files\input_video\%n% -r 24 -f image2 files\png_frames_default\%%06d.png
ffmpeg.exe -i files\input_video\%n% files\temp_audio\audio.mp3
echo please wait...
for %%f in (files\png_frames_default\*.*) do call waifu2x-caffe-cui.exe -m noise_scale --noise_level 2 --scale_ratio 2 -i files\png_frames_default\%%~nxf -o files\png_frames_upscaled\%%~nxf > NUL | title %%~nf | <nul set /p=%%~nf
ffmpeg.exe -f image2 -framerate 24 -i files\png_frames_upscaled\%%06d.png -i files\temp_audio\audio.mp3 -r 24 -vcodec libx264 -crf 18 files\output_video\output.%e%
set n=err & set e=err
rmdir files\input_video /s /q
rmdir files\temp_audio /s /q
rmdir files\png_frames_default /s /q
rmdir files\png_frames_upscaled /s /q
echo ok
title ok
explorer %cd%\files\output_video
pause