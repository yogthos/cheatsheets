download audio only

    youtube-dl -f 'bestaudio[ext=m4a]' <video url>
    youtube-dl -x --audio-format mp3 <video url>
    youtube-dl -x --embed-thumbnail --audio-format mp3 <video url>
    #download playlist
    youtube-dl -x --embed-thumbnail --audio-format mp3 -cit <playlist_url>
