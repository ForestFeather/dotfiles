import json
from lxml import etree
import os
from datetime import datetime
from glob import glob
import cgi

files = glob(os.path.basename(os.getcwd() + "/*.info.json"))

#loop for all files
for i in range(len(files)):

    # Read file contents to string
    json_file = open(files[i], "r")
    json_content = json_file.read()
    json_file.close()

    # Parse the json
    parsed_json = json.loads(json_content)

    # Write out to new file
    # ITEMS TO WRITE:  Title(fulltitle), Playlist(showtitle), Rating(ratings/rating name/etc),Tags(genre),Update_date(aired), Thumbnail/URL(thumb), Description(plot),
    nfo_file = open(files[i][:-10] + '.nfo', 'w+')
    root = etree.Element('episodedetails')
    xfulltitle = etree.Element('title')
    xfulltitle.text = parsed_json['title']
    root.append(xfulltitle)
    xshowtitle = etree.Element('showtitle')
    xshowtitle.text = parsed_json['playlist']
    root.append(xshowtitle)
    xseason = etree.Element('season')
    xseason.text = '1'
    root.append(xseason)
    xepisode = etree.Element('episode')
    xepisode.text = str(parsed_json['playlist_index'])
    root.append(xepisode)
    xratings = etree.Element('ratings')
    xrating = etree.Element('rating')
    xrating.set('name', 'youtube')
    xrating.set('max', '5')
    xrating.set('default', 'true')
    xvalue = etree.Element('value')
    xvalue.text = str(parsed_json['average_rating'])
    xrating.append(xvalue)
    xvotes = etree.Element('votes')
    xvotes.text = str(int(parsed_json['like_count'] or 0) + int(parsed_json['dislike_count'] or 0))
    xrating.append(xvotes)
    xratings.append(xrating)
    root.append(xratings)
    xplot = etree.Element('plot')
    xplot.text = cgi.escape(parsed_json['description'])
    root.append(xplot)
    xthumb = etree.Element('thumb')
    xthumb.text = str(parsed_json['thumbnails'][0]['url'])
    root.append(xthumb)
    if parsed_json['tags']:
        for j in range(len(parsed_json['tags'])):
            xgenre = etree.Element('genre')
            xgenre.text = parsed_json['tags'][j]
            root.append(xgenre)
    xdirector = etree.Element('director')
    xdirector.text = parsed_json['uploader']
    root.append(xdirector)
    xaired = etree.Element('aired')
    date_string = parsed_json['upload_date']
    date = datetime(year=int(date_string[0:4]), month=int(date_string[4:6]), day=int(date_string[6:8]))
    date_string = date.strftime('%Y-%m-%d')
    xaired.text = date_string
    root.append(xaired)

    nfo_contents = etree.tostring(root, pretty_print=True)
    nfo_file.write(nfo_contents)
    nfo_file.close()
