loop audio to the length of the video

    ffmpeg  -i video.mp4 -stream_loop -1 -i audio.mp3 -shortest -map 0:v:0 -map 1:a:0 -y out.mp4
    
loop video to the length of the audio

    ffmpeg  -stream_loop -1 -i video.mp4 -i audio.mp3 -shortest -map 0:v:0 -map 1:a:0 -y out.mp4
    
convert video for Twitter

    ffmpeg -i video.mp4 -vcodec libx264 -vf 'scale=640:trunc(ow/a/2)*2' -acodec aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k -ar 44100 -strict experimental -r 30 out.mp4

resize a video

    ffmpeg -i video -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" resized.mp4
    
batch convert m4a to mp3

    find . -type f -name "*.m4a" -exec bash -c 'ffmpeg -i "$1" "${1/m4a/mp3}"' -- {} \;
