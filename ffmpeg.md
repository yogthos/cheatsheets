convert iTunes mp4 to mp3 and strip DRM:

    find . -type f -name "*.m4a" -exec bash -c 'ffmpeg -i "$1" "${1/m4a/mp3}" && rm "$1"' -- {} \;

    for f in *.m4a; do ffmpeg -i "$f" -codec:v copy -codec:a libmp3lame -q:a 2 "${f%.m4a}.mp3"; done

extract audio

    ffmpeg -i Sample.avi -vn -ar 44100 -ac 2 -ab 192k -f mp3 Sample.mp3

batch convert files

    for f in *.flac; do ffmpeg -i "$f" -c:a libmp3lame "${f%.flac}.mp3"; done

convert images to video

    ffmpeg -framerate 10 -i filename-%d.jpg video.mp4

add image to an audio clip

    ffmpeg -i image.jpg -i audio.mp3 -vf scale=640:-1 -c:v libx264 -tune stillimage -c:a aac -b:a 192k out1.mp4

loop audio to the length of the video

    ffmpeg  -i video.mp4 -stream_loop -1 -i audio.mp3 -shortest -map 0:v:0 -map 1:a:0 -y out.mp4
    
loop video to the length of the audio

    ffmpeg  -stream_loop -1 -i video.mp4 -i audio.mp3 -shortest -map 0:v:0 -map 1:a:0 -y out.mp4

concat videos

    ffmpeg -i vid1.webm -i vid2.webm \
      -filter_complex "[0:v] [0:a] [1:v] [1:a] \
    concat=n=2:v=1:a=1 [v] [a]" \
      -map "[v]" -map "[a]" final.mp4

make a gif

    -vf "fps=15,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128:stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle"

    # with text
    ffmpeg -i input_video.mp4 \
    -vf "fps=15,scale=320:-1:flags=lanczos,drawtext=text='My Custom Text':fontsize=24:fontcolor=white:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=h-th-10,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    output.gif

    # reversed
    -vf "fps=15,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse,reverse,fifo" \
-ss 00:00:00 -t 00:00:10 -loop 0

reduce size

CRF parameter sets the quality and influences the file size. Lower values mean higher quality, and typical values are from 18 to 28 (higher means more compression). The default is 23.
CRF 18 is well known for producing a (arguably) "visually lossless" result:

    ffmpeg -i input.avi -c:v libx264 -crf 18 -preset veryslow -c:a copy out.mp4
    
Command-line - Compress and Convert MP4 to WMV

    ffmpeg -i input.mp4 -b 1000k -vcodec wmv2 -acodec wmav2 -crf 19 -filter:v fps=fps=24 output.wmv

Command-line - Compress and Convert MP4 to Webm for YouTube, Ins, Facebook

    ffmpeg -i source.mp4 -c:v libvpx-vp9 -b:v 0.33M -c:a libopus -b:a 96k -filter:v scale=960x540 target.webm

Command-line - Compress and Convert H.264 to H.265 for Higher Compression

    ffmpeg -i input.mp4 -vcodec libx265 -crf 28 output.mp4

Command-line -Set CRF in FFmpeg to Reduce Video File Size

    ffmpeg -i input.mp4 -vcodec libx264 -crf 24 output.mp4

Command-line - Reduce video frame size to make 4K/1080P FHD video smaller

    ffmpeg -i input.avi -vf scale=1280:720 output.avi

Command-line - resize video in FFmpeg to reduce video size

    ffmpeg -i input.avi -vf scale=852×480 output.avi

to preserve aspect ratio:

    ffmpeg -i input.avi -vf scale=852:-1 output.avi

add text to video


    ffmpeg -i input.mp4 \
    -vf "drawtext=text='some text':fontsize=14:fontcolor=white:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=h-th-10" \
    output.mp4

    ## use new lines to split up text (no need for control characters)

add text with custom font

    ffmpeg -i input.mp4 -vf drawtext="fontfile=/path/to/font.ttf: \
    text='Stack Overflow': fontcolor=white: fontsize=24: box=1: boxcolor=black@0.5: \
    boxborderw=5: x=(w-text_w)/2: y=(h-text_h)/2" -codec:a copy output.mp4

remove location

    ffmpeg -i input.mp4 -metadata location="" -metadata location-eng="" -acodec copy -vcodec copy output.mp4

blur region

crop flag will crop a region of 420x130 starting at 10x10px from top left

    ffmpeg -i input.mp4 -filter_complex "[0:v]crop=420:130:60:30,boxblur=10[fg];[0:v][fg]overlay=10:10[v]" -map "[v]" blurred.mp4

Crop the copy to be the size of the area to be blurred. In this example: a 420x130 pixel box that is 60 pixels to the right (x axis) and 30 pixels down (y axis) from the top left corner. Overlay will decide where in the resulting video the blur will be applied. Alternatively, can use names parameters: `crop=w=300:h=50:x=435:y=720`.

**cut a section of a video**

    ffmpeg -i input.mp4 -ss 00:00:00 -t 00:28:00 -async 1 -strict -2 cut.mp4


#### stack videos 

vertically

    ffmpeg -i input0 -i input1 -filter_complex vstack=inputs=2 output.mp4
    
horizontally

    ffmpeg -i input0 -i input1 -filter_complex hstack=inputs=2 output

with a border

    ffmpeg -i input0 -i input1 -filter_complex "[0]pad=iw+5:color=black[left];[left][1]hstack=inputs=2" output

with audio

downmix and use original channel placements

    ffmpeg -i input0 -i input1 -filter_complex "[0:v][1:v]vstack=inputs=2[v];[0:a][1:a]amerge=inputs=2[a]" -map "[v]" -map "[a]" -ac 2 output

put all audio from each input into separate channels

    ffmpeg -i input0 -i input1 -filter_complex "[0:v][1:v]vstack=inputs=2[v];[0:a][1:a]amerge=inputs=2,pan=stereo|c0<c0+c1|c1<c2+c3[a]" -map "[v]" -map "[a]"  output

using audio from one particular input

    ffmpeg -i input0 -i input1 -filter_complex "[0:v][1:v]vstack=inputs=2[v]" -map "[v]" -map 1:a output

adding silent audio / If one input does not have audio

    ffmpeg -i input0 -i input1 -filter_complex "[0:v][1:v]vstack=inputs=2[v];anullsrc[silent];[0:a][silent]amerge=inputs=2[a]" -map "[v]" -map "[a]" -ac 2 output.mp4

3 videos or images

    ffmpeg -i input0 -i input1 -i input2 -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[v]" -map "[v]" output

2x2 grid

    ffmpeg -i input0 -i input1 -i input2 -i input3 -filter_complex "[0:v][1:v][2:v][3:v]xstack=inputs=4:layout=0_0|w0_0|0_h0|w0_h0[v]" -map "[v]" output

#### convert video for Twitter

one of these should work

    ffmpeg -i video.mp4 -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p -strict experimental -r 30 -t 2:20 -acodec aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k -ar 44100 -ac 2 out.mp4

    ffmpeg -i video.mp4 -vcodec libx264 -vf 'scale=640:trunc(ow/a/2)*2' -acodec aac -vb 1024k -minrate 1024k -maxrate 1024k -bufsize 1024k -ar 44100 -strict experimental -r 30 out.mp4
     
    ffmpeg -i $input -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac ${input%.*}.mp4

resize a video

    ffmpeg -i input.mp4 -vf scale=320:-1 output.mp4 

    ffmpeg -i video -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" resized.mp4
    
    ffmpeg -i video -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -c:v libx265 -preset fast -tag:v hvc1 -b:v 10000 -c:a copy  resized.mp4
    
Crop a video

The syntax for cropping a video is `crop=width:height:x:y`. With this, here is a command line that crops a 200×200 portion of a video.

    -filter:v "crop=1600:1080:160:0" -c:a copy #preserves sound
    
    ffmpeg -i input.mp4 -filter_complex "[0:v]crop=200:200:300:100[cropped]" -map "[cropped]" output.mp4

This command results in a 200x200 cropped portion of the video situated 300 pixels from the left edge and 100 pixels from the top edge.

If the parameters `300:100` is not provided, the resulting portion will be taken from the center of the video.

The input video’s width and height can be denoted by in_w / iw and in_h / ih respectively. An example of cropping a video in FFmpeg using variables instead of specifying the literal pixel coordinates.

    ffmpeg -i input.mp4 -filter_complex "[0:v]crop=in_w/2:in_h/2[cropped]" -map "[cropped]" output.mp4

Bottom right corner: `ffmpeg -i video.mp4 -filter_complex crop=in_w/2:in_h/2:in_w/2:in_h/2 video-out.mp4`
Remove $x pixels from the top and bottom: `ffmpeg -i video.mp4 -filter_complex crop=in_w:in_h-2*$x video-out.mp4`
Remove  $x pixels from either side of the video: `ffmpeg -i video.mp4 -filter_complex crop=in_w-2*$x:in_h video-out.mp4`

(BR) Modify the bitrate, using:

    ffmpeg -i $infile -b $bitrate $newoutfile 

(CR) Vary the Constant Rate Factor, using:

    ffmpeg -i $infile -vcodec libx264 -crf 23 $outfile

(SZ) Change the video screen-size (for example to half its pixel size), using:

    ffmpeg -i $infile -vf "scale=iw/2:ih/2" $outfile

(BL) Change the H.264 profile to "baseline", using:

    ffmpeg -i $infile -profile:v baseline $outfile

(DF) Use the default ffmpeg processing, using:

    ffmpeg -i $infile $outfile
    
e.g:    
    
    ffmpeg -i capitalism.mp4 -vf "scale=iw/4:ih/4" -crf 23 -b 800k capitalism-small.mp4

    ffmpeg -i input-file.mp4 -vf scale=-1:200 output-file.mp4
    
batch convert m4a to mp3

    find . -type f -name "*.m4a" -exec bash -c 'ffmpeg -i "$1" "${1/m4a/mp3}"' -- {} \;

specify the Width To Retain the Aspect Ratio

    ffmpeg -i input.mp4 -vf scale=320:-1 output.mp4

The resulting video will have a resolution of 320x180. This is because 1920 / 320 = 6. Thus, the height is scaled to 1080 / 6 = 180 pixels.

specify the Height To Retain the Aspect Ratio

    ffmpeg -i input.mp4 -vf scale=-1:720 output.mp4

figuring out video resolution

    ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 input.mp4

resize without quality loss

    ffmpeg -i input.mp4 -vf scale=1280:720 -preset slow -crf 18 output.mp4

The input video’s width and height are denoted by iw and ih respectively, to scale the video’s width two times (2x):

    ffmpeg -i input.mp4 -vf scale=iw*2:ih output.mp4

to divide either the height or width by a number, the syntax changes a little as the scale=iw/2:ih/2 argument need to be enclosed within double quotes:

    ffmpeg -i input.mp4 -vf "scale=iw/2:ih/2" output.mp4  

prevent upscaling

    ffmpeg -i input.mp4 -vf "scale='min(320,iw)':'min(240,ih)'" output.mp4
    
in the command line above, the minimum width/height to perform scaling is set to 320 and 240 pixels respectively. This is a very simple way to guard against poor quality scaling. 

## Converting Audio into Different Formats / Sample Rates
Minimal example: transcode from MP3 to WMA:<br>
`ffmpeg -i input.mp3 output.wma`
 
You can get the list of supported formats with:<br>
`ffmpeg -formats`
 
Convert WAV to MP3, mix down to mono (use 1 audio channel), set bit rate to 64 kbps and  sample rate to 22050 Hz:<br>
`ffmpeg -i input.wav -ac 1 -ab 64000 -ar 22050 output.mp3`<br>

Convert any MP3 file to WAV 16khz mono 16bit:<br>
`ffmpeg -i 111.mp3 -acodec pcm_s16le -ac 1 -ar 16000 out.wav`<br>

Convert any MP3 file to WAV 20khz mono 16bit for ADDAC WAV Player:<br>
`ffmpeg -i 111.mp3 -acodec pcm_s16le -ac 1 -ar 22050 out.wav`<br>
cd into dir for batch process:<br>
`for i in *.mp3; do ffmpeg -i "$i" -acodec pcm_s16le -ac 1 -ar 22050 "${i%.mp3}-encoded.wav"; done`

Picking the 30 seconds fragment at an offset of 1 minute:<br>
In seconds<br>
`ffmpeg -i input.mp3 -ss 60 -t 30 output.wav`<br>

In HH:MM:SS format<br>
`ffmpeg -i input.mp3 -ss 0:01:00 -t 0:00:30 output.wav`

Split an audio stream at specified segment rate (e.g. 3 seconds)<br>
`ffmpeg -i somefile.mp3 -f segment -segment_time 3 -c copy out%03d.mp3`<br>

## Extract Audio

`ffmpeg -i input-video.avi -vn -acodec copy output-audio.aac `

`vn` is no video.<br>
`acodec` copy says use the same audio stream that's already in there.


`ffmpeg -i video.mp4 -f mp3 -ab 192000 -vn music.mp3`

The -i option in the above command is simple: it is the path to the input file. The second option -f mp3 tells ffmpeg that the ouput is in mp3 format. The third option i.e -ab 192000 tells ffmpeg that we want the output to be encoded at 192Kbps and -vn tells ffmpeg that we dont want video. The last param is the name of the output file.

## Replace Audio on a Video without re-encoding.

strip audio stream away from video<br>
`ffmpeg -i INPUT.mp4 -codec copy -an OUTPUT.mp4`

combine the two streams together (new audio with originally exisiting video)<br>
`ffmpeg -i INPUT.mp4 -i AUDIO.wav -shortest -c:v copy -c:a aac -b:a 256k OUTPUT.mp4`

- - - 

You say you want to "extract audio from them (mp3 or ogg)". But what if the audio in the mp4 file is not one of those? you'd have to transcode anyway. So why not leave the audio format detection up to ffmpeg?

To convert one file:

` ffmpeg -i videofile.mp4 -vn -acodec libvorbis audiofile.ogg `

To convert many files:

` for vid in *.mp4; do ffmpeg -i "$vid" -vn -acodec libvorbis "${vid%.mp4}.ogg"; done `

You can of course select any ffmpeg parameters for audio encoding that you like, to set things like bitrate and so on.

Use ` -acodec libmp3lame `  and change the extension from `.ogg` to `.mp3` for mp3 encoding.

If what you want is to really extract the audio, you can simply "copy" the audio track to a file using -acodec copy. Of course, the main difference is that transcoding is slow and cpu-intensive, while copying is really quick as you're just moving bytes from one file to another. Here's how to copy just the audio track (assuming it's in mp3 format):

` ffmpeg -i videofile.mp4 -vn -acodec copy audiofile.mp3 `

Note that in this case, the audiofile format has to be consistent with what the container has (i.e. if the audio is AAC format, you have to say audiofile.aac). You can use the ffprobe command to see which formats you have, this may provide some information:

` for file in *; do ffprobe $file 2>&1 |grep Audio; done `

A possible way to automatically parse the audio codec and name the audio file accordingly would be:

` for file in *mp4 *avi; do ffmpeg -i "$file" -vn -acodec copy "$file".`ffprobe "$file" 2>&1 |sed -rn 's/.*Audio: (...), .*/\1/p'`; done `

Note that this command uses sed to parse output from ffprobe for each file, it assumes a 3-letter audio codec name (e.g. mp3, ogg, aac) and will break with anything different.

- - - 

Encoding multiple files

You can use a Bash "for loop" to encode all files in a directory:

`$ mkdir newfiles` <br>
`$ for f in *.m4a; do ffmpeg -i "$f" -codec:v copy -codec:a libmp3lame -q:a 2 newfiles/"${f%.m4a}.mp3"; done`

- - - 

`ffmpeg -i input.m4a -acodec libmp3lame -ab 128k output.mp3` <br>
m4a to mp3 conversion with ffmpeg and lame

A batch file version of the same command would be:<br>
`for f in *.m4a; do ffmpeg -i "$f" -acodec libmp3lame -ab 256k "${f%.m4a}.mp3"; done`

- - - 

## Extract Single Image from a Video at Specified Frame
`$ vf [ss][filename][outputFileName]`<br>
where `vf` is a custom bash script as follows:<br>
`$ ffmpeg -ss $1 -i $2 -qmin 1 -q:v 1 -qscale:v 2 -frames:v 1 -huffman optimal $3.jpg`<br>
<br>
ss offset = frame number divided by FPS of video = the decimal (in milliseconds) ffmpeg needs i.e. 130.5<br>

## Merge Multiple Videos

file names in folder, if they contain spaces, must be properly escaped <br>
`ls * | perl -ne 'print "file $_"' | ffmpeg -f concat -i - -c copy merged.mp4`

## Split a Video into Images
`$ ffmpeg -i video.flv image%d.jpg`

## Convert Images into a Video
`$ ffmpeg -f image2 -i image%d.jpg imagestovideo.mp4`<br>
`$ ffmpeg -i image-%03d.png -c:v libx264 -pix_fmt yuv420p test.mp4`<br>
`$ ffmpeg -r 1/5 -i image-%03d.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p test.mp4`<br>

## Convert non-sequentially named Images in a directory 
`$ ffmpeg -framerate 30 -pattern_type glob -i '*.jpeg' -c:v libx264 -pix_fmt yuv420p gan-1.mov`<br>

## Convert mp4 to webm
`$ ffmpeg -i example.mp4 -f webm -c:v libvpx -b:v 1M -acodec libvorbis example.webm -hide_banner`<br>
[more info](http://www.bugcodemaster.com/article/convert-videos-webm-format-using-ffmpeg)

## Simple FLAC convert
`ffmpeg -i audio.xxx -c:a flac audio.flac`

## Mix Stereo to Mono
You can modify a video file directly without having to re-encode the video stream. However the audio stream will have to be re-encoded.
<br>
Left channel to mono:
`ffmpeg -i video.mp4 -map_channel 0.1.0 -c:v copy mono.mp4`<br>
<br>
Left channel to stereo:<br>
`ffmpeg -i video.mp4 -map_channel 0.1.0 -map_channel 0.1.0 -c:v copy stereo.mp4`<br>
<br>
If you want to use the right channel, write `0.1.1` instead of `0.1.0.`

## Trim End of file (mp3)
Here's a command line that will slice to 30 seconds without transcoding:
<br>
`ffmpeg -t 30 -i inputfile.mp3 -acodec copy outputfile.mp3`
<br>

- - -

## To Encode or Re-encode ?

Do you need to cut video with re-encoding or without re-encoding mode? You can try to following below command.<br>
Synopsis: ffmpeg -i [input_file] -ss [start_seconds] -t [duration_seconds] [output_file]

#### use ffmpeg cut mp4 video without re-encoding

Example:<br>
`ffmpeg -i source.mp4 -ss 00:00:05 -t 00:00:10 -c copy cut_video.mp4`<br>

#### use ffmpeg cut mp4 video with re-encoding

Example:<br>
`ffmpeg -i source.mp4 -ss 00:00:05 -t 00:00:10 -async 1 -strict -2 cut_video.mp4`<br>

If you want to cut off section from the beginning, simply drop -t 00:00:10 from the command

#### reduce filesize

Example:<br>
`ffmpeg -i input.avi -vcodec libx265 -crf 24 output.avi`<br>
<br>
It reduced a 100mb video to 9mb.. Very little change in video quality.

Example:<br>
`ffmpeg -i video.mov -vf eq=saturation=0 -s 640x480 -c:v libx264 -crf 24 output.mp4`<br>
<br>
make a grayscale version and scale to 640x480

### Convert MKV to MP4
`ffmpeg -i file.mkv`<br>
<br>
check for streams that you want (video/audio). be sure to convert/specify DTS 6 channel audio stream<br>
<br>
`ffmpeg -i input.mkv -strict experimental -map 0:0 -map 0:1 -c:v copy -c:a:1 libmp3lame -b:a 192k -ac 6 output.mp4`
<br>
### Add Watermark overlay (png) to the center of a video
`ffmpeg -i source.mov -i watermark.png -filter_complex "overlay=x=(main_w-overlay_w)/2:y=(main_h-overlay_h)/2" output.mp4`
<br>
- - -
more commands<br>
http://www.catswhocode.com/blog/19-ffmpeg-commands-for-all-needs

### FFmpeg Explorer

* https://ffmpeg.lav.io/
* https://github.com/antiboredom/ffmpeg-explorer/
