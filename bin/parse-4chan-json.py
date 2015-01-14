#!/usr/bin/env python
# coding=utf-8

# TODO - show all replies to a post
# TODO - make images drag-resizeable, like RES
# TODO - handle webm/mp4

import sys
import os
import json
from string import Template
import codecs

JQUERY_LOC = os.path.expanduser("~/bin/jquery.min.js")
JSON_LOC = ""

STYLESHEET = u"""
html{-moz-text-size-adjust:100%;-webkit-text-size-adjust:100%;-ms-text-size-adjust:100%;}
body{background:#EEF2FF url(/image/fade-blue.png) top center repeat-x;color:#000000;font-family:arial,helvetica,sans-serif;font-size:10pt;margin-left:0;margin-right:0;margin-top:5px;padding-left:5px;padding-right:5px;}
.party-hat{left:0;margin-top:-80px;position:absolute;}
.centeredThreads .party-hat{left:12%;}
#disclaimer{font-size:14px;position:absolute;overflow:hidden;top:0;left:0;width:100%;height:100%;z-index:9998;}
#disclaimer a{color:#0000ff;}
#disclaimer-bg{position:fixed;top:0;left:0;width:100%;height:100%;background-color:rgba(0,0,0,0.25);}
#disclaimer-modal{z-index:9999;width:320px;top:0;left:50%;margin-left:-170px;display:block;padding:10px;position:relative;background-color:#d6daf0;box-shadow:0 0 5px rgba(0,0,0,0.25);}
#disclaimer ol{margin-left:20px;padding:0;}
#disclaimer li{margin:10px 0;}
#disclaimer h3{border-bottom:1px solid #b7c5d9;margin:0;padding-bottom:5px;text-align:center;}
#disclaimer-modal div{margin-top:10px;text-align:center;}
#disclaimer-modal button{margin:0 10px;}
#disclaimer-accept{font-weight:bold;}
.isMobileDevice blockquote.postMessage{font-size:11pt;}
.belowLeaderboard{width:728px;max-width:100%;}
.aboveMidAd{width:468px;max-width:100%;}
#recaptcha_table{background-color:transparent!important;border:none!important;}
.recaptcha_image_cell{background-color:transparent!important;}
#recaptcha_div{height:107px;width:442px;}
#recaptcha_challenge_field{width:400px}
@media only screen and (min-width: 481px) {.recaptcha_input_area{padding:0!important;}
#recaptcha_table tr:first-child{height:auto!important;}
#recaptcha_table tr:first-child>td:not(:first-child){padding:0 7px 0 7px!important;}
#recaptcha_table tr:last-child td:last-child{padding-bottom:0!important;}
#recaptcha_table tr:last-child td:first-child{padding-left:0!important;}
#recaptcha_image{cursor:pointer;}
#recaptcha_response_field{width:292px;margin-right:0px!important;font-size:10pt!important;}
input:-moz-placeholder{color:gray!important;}
#recaptcha_image{border:1px solid #aaa!important;}
#recaptcha_table tr>td:last-child{display:none!important;}
#captchaContainer{width:343px;height:86px;line-height:99px;overflow:hidden;}
#captchaContainer .placeholder{font-style:italic;padding-left:5px;}
}
.mobile,.mobileinline,.mobileib{display:none!important;}
a,a:visited{color:#34345C;text-decoration:none;}
a.replylink:not(:hover),div#absbot a:not(:hover){color:#34345C!important;}
a:hover{color:#DD0000!important;}
div#absbot{color:#000000;clear:both;}
img{border:none;}
img.topad,.topad>div,.topad a img{width:728px;height:90px;max-width:100%;overflow:hidden;margin:auto;}
img.middlead,.middlead>div,.middlead a img{width:468px;height:60px;max-width:100%;overflow:hidden;margin:auto;}
img.bottomad,.bottomad>div,.bottomad a img{width:728px;height:90px;max-width:100%;overflow:hidden;margin:auto;}
hr{border:none;border-top:1px solid #B7C5D9;height:0;}
div.board>hr{clear:both;}
hr.abovePostForm{width:90%;}
span.x-small{font-size:x-small;}
div.backlink{font-size:x-small!important;padding-left:10px;padding-bottom:5px;padding-right:10px;}
.backlink span{padding-right:5px;}
#fileError{font-weight:bold;color:red;}
.mobile{display:none;}
ul.rules{margin:0px;padding:0px;margin-top:5px;}
ul.rules>li{list-style:none;font-size:11px;}
div.boardBanner{text-align:center;clear:both;color:#AF0A0F;}
#bannerCnt{border:1px solid #34345C;margin:5px auto;width:300px;height:100px;max-width:100%;}
div.boardBanner>div.boardTitle{font-family:Tahoma,sans-serif;font-size:28px;font-weight:bold;letter-spacing:-2px;margin-top:0px;}
div.boardBanner>div.boardSubtitle{font-size:x-small;}
div#boardNavDesktop{font-size:9pt;color:#89A;display:block;}
.hasDropDownNav #navtopright{display:none;}
#boardNavDesktop .pageJump{padding:0;}
#boardNavDesktop .pageJump a{padding-right:5px;}
div#boardNavDesktop a{font-weight:normal;padding:1px;text-decoration:none;color:#34345C;}
div.pContainer{}
div.opContainer{display:inline;}
div.sideArrows{color:#B7C5D9;float:left;margin-right:2px;margin-top:0px;margin-left:2px;}
div.thread{margin:0px;clear:both;}
div.post{margin:4px 0;overflow:hidden;}
div.thread>div:nth-of-type(2)>div.reply{margin-top:2px!important;}
div.op{display:inline;}
div.reply{background-color:#D6DAF0;border:1px solid #B7C5D9;border-left:none;border-top:none;display:table;padding:2px;}
div.reply input{float:none;}
div.post div.postInfo{display:block;width:100%;}
div.post div.postInfo span.postNum{}
div.post div.postInfo span.postNum a{text-decoration:none;color:#000000;}
div.post div.postInfo span.postNum a:hover,.posteruid .hand:hover{color:#DD0000!important;}
div.post div.postInfo span.nameBlock{display:inline-block;}
div.post div.postInfo span.nameBlock span.name{color:#117743;font-weight:bold;}
div.post div.postInfo span.nameBlock span.postertrip{color:#117743;font-weight:normal!important;}
div.post div.postInfo span.date{}
div.post div.postInfo span.time{}
div.post div.postInfo span.subject{color:#0F0C5D;font-weight:bold;}
div.post blockquote.postMessage{display:block;}
blockquote>span.quote{color:#789922;}
.quoteLink,.quotelink,.deadlink{color:#D00!important;text-decoration:underline;}
div.post div.file{display:block;}
div.post div.file div.fileInfo{margin-right:10px;}
div.replyContainer div.post div.file div.fileInfo{margin-left:20px;}
div.post div.file .fileThumb{float:left;margin-left:20px;margin-right:20px;margin-top:3px;margin-bottom:5px;}
span.fileThumb{margin-left:0px!important;margin-right:5px!important;}
div.reply span.fileThumb,div.reply span.fileThumb img{float:none!important;margin-top:0px!important;margin-bottom:0px!important;}
div.post div.file .fileThumb img{border:none;float:left;}
span.summary{color:#707070;margin-top:10px;}
div.postingMode{background-color:#e04000;padding:1px;text-align:center;color:#fff;font-weight:bold;font-size:larger;margin-top:8px;}
#verification table{border:none!important;margin:0px;}
div.thread:last-child{padding-bottom:21px;margin-bottom:6px;}
div.pagelist{font-size:13px!important;margin:0;padding:3px 7px;float:left;border:none;background:#D6DAF0;border-right:1px solid #B7C5D9;border-bottom:1px solid #B7C5D9;list-style:none;overflow:hidden;color:#89A;}
div.pagelist>div{float:left;}
div.pagelist>div span{padding:4px;display:inline-block;}
div.pagelist div.pages{padding:4px;}
div.pagelist div.pages a{text-decoration:none!important;}
div.pagelist form{display:inline;}
div.pagelist strong{color:#000000;}
div.pagelist div.cataloglink{border-left:1px solid #B7C5D9;padding-left:12px;margin-left:7px;}
.bottomCtrl{float:right;margin-top:2px;}
input[type=password]{width:50px;text-align:center;}
div.deleteform input[type=checkbox]{margin:1px 2px 1px 2px;}
.stylechanger{margin-left:5px;font-size:10pt;}
div#boardNavDesktopFoot{font-size:9pt;color:#89A;clear:both;padding-top:10px;padding-bottom:3px;}
div#boardNavDesktopFoot a{font-weight:normal;padding:1px;text-decoration:none;color:#34345C;}
div.homelink{float:right}
div#absbot{text-align:center;font-size:x-small!important;padding-bottom:4px;padding-top:10px;color:#000;}
#recaptcha_response_field{padding:0px;}
table{border-spacing:1px;margin-left:auto;margin-right:auto;}
table.postForm>tbody>tr>td:first-child{background-color:#98E;color:#000;font-weight:bold;border:1px solid #000;padding:0 5px;font-size:10pt;}
tr.rules td{border:0px!important;background-color:transparent!important;font-weight:normal!important;}
td{margin:0px;padding:0px;font-size:10pt;}
input[type=text],input[type=password],table.postForm>tbody textarea,#recaptcha_response_field{margin:0px;margin-right:2px;padding:2px 4px 3px 4px;border:1px solid #AAA;outline:none;font-family:arial,helvetica,sans-serif;font-size:10pt;}
#recaptcha_response_field:not(:focus){border:1px solid #AAA!important;}
input[type=text]:focus,input[type=password]:focus,input:not([type]):focus,textarea:focus{border:1px solid #9988EE!important;}
table.postForm>tbody>tr>td>input[type=text]{width:244px;}
table.postForm>tbody>tr>td>input[name="subject"]{width:300px;}
.postblock{background-color:#98E;color:#000;font-weight:bold;border:1px solid #000;padding:0 5px;font-size:10pt;}
div.closed{font-size:x-large;text-align:center;color:red;font-weight:bold;padding-top:100px;padding-bottom:100px;}
@media screen and (-webkit-min-device-pixel-ratio:0) {tbody textarea{margin-bottom:-3px!important;width:292px}
}
.commentpostername{font-weight:bold;}
.identityIcon{margin-bottom:-3px;height:16px;width:16px;}
.stickyIcon{margin-bottom:-1px;padding-left:2px;height:16px;width:16px;}
.archivedIcon,.closedIcon{margin-bottom:-1px;margin-left:-1px;height:16px;width:16px;}
.trashIcon{width:16px;height:16px;margin-bottom:-2px;}
.fileDeleted{height:13px;width:172px;}
.fileDeletedRes{height:13px;width:127px;}
.navSmall{font-size:90%;}
.center{text-align:center;}
.bold{font-weight:bold;}
.smaller{font-size:smaller;}
.password{font-size:smaller;}
.passNotice{font-size:smaller;padding-left:6px;}
.qcDiv{display:none;}
.qcImg{height:1px;width:1px;border:0px;}
.jpnFlag{height:11px;width:17px;}
.globalMessage{color:red;text-align:center;}
.highlightPost:not(.op){background:#c1c6e2!important;border-color:#7b82ac!important;}
.reply:target,.reply.highlight{background:#D6BAD0!important;border:1px solid #BA9DBF!important;border-left:none!important;border-top:none!important;padding:2px;}
.useremail:not(:hover) .name:not(.capcode),.useremail:not(:hover) .postertrip:not(.capcode){color:#34345C!important;}
.hand{cursor:pointer;}
.nameBlock.capcodeAdmin span.name,span.capcodeAdmin a span.name,span.capcodeAdmin span.postertrip,span.capcodeAdmin strong.capcode{color:#F00!important;}
.nameBlock.capcodeMod span.name,span.capcodeMod a span.name,span.capcodeMod span.postertrip,span.capcodeMod strong.capcode{color:#800080!important;}
.nameBlock.capcodeDeveloper span.name,span.capcodeDeveloper a span.name,span.capcodeDeveloper span.postertrip,span.capcodeDeveloper strong.capcode{color:#0000F0!important;}
.nameBlock.capcodeManager span.name,span.capcodeManager a span.name,span.capcodeManager span.postertrip,span.capcodeManager strong.capcode{color:#FF0080!important;}
.useremail *:hover,.useremail:hover *{color:#DD0000!important;}
#reportTypes a,.useremail{text-decoration:underline;}
.omittedposts,.abbr{color:#707070;}
span.spoiler{color:#000!important;background:#000!important;}
span.spoiler:hover,span.spoiler:focus{color:#fff!important;}
s,s a:not(:hover){color:#000!important;background:#000!important;text-decoration:none;}
s:hover,s:focus,s:hover a{color:#fff!important;}
s:hover a{text-decoration:underline;}
table.exif{display:none;min-width:450px;}
table.exif td{color:#070707;min-width:150px;font-size:8pt;}
table.exif td b{text-decoration:underline;}
#navtopright,#navbotright{float:right;}
.preview{background-color:#D6DAF0;border:1px solid #B7C5D9!important;border-right-width:2px!important;border-bottom-width:2px!important;}
div.posthover{max-width:400px;margin-left:20px;}
div.posthover{padding:5px;padding-left:10px;padding-right:10px;}
div.posthover a.fileThumb{margin-left:5px!important;margin-right:10px!important;}
div.posthover blockquote{margin:5px;}
div.posthover img[data-md5]{max-width:80px;max-height:80px;width:auto!important;height:auto!important;}
div.posthover div.fileThumb{margin-left:0px!important;margin-right:10px!important;}
#settingsBox{position:absolute;right:10px;margin-top:10px;}
.persistentNav,div#boardNavMobile{padding:2px 4px;background-color:#D6DAF0;overflow:hidden;border-bottom:2px solid #B7C5D9;position:fixed;top:0px;left:0px;right:0px;font-size:12px;z-index:9001;}
div#boardNavMobile select,div#boardNavMobile option{font-size:11px;}
div.boardSelect{float:left;}
div.boardSelect>strong{padding-right:5px;}
div.pageJump{float:right;padding-right:5px;padding-top:3px;}
.pageJump a{text-decoration:none;padding-right:5px;}
div.qrWindow{position:absolute;z-index:8000;}
div.qrHeader{padding:2px;font-size:small;text-align:center;}
div.qrForm{padding:3px;}
span.qrButtonHolder{position:absolute;right:5px;text-align:right;top:3px;}
span.qrButtonHolder a{text-decoration:none;}
span.qrButtonHolder img{cursor:pointer;margin-bottom:-1px;margin-top:1px;}
.extButton img{margin-top:3px;margin-bottom:-3px;margin-left:4px;}
.qrMessage{padding:2px;text-align:center;}
.op .backlinkHr{width:55%;}
img.expandedImg{max-width:none!important;max-height:none!important;}
#captchaContainer>img{float:left;border:1px solid #aaa;margin-bottom:1px;}
#captchaInfo{float:left;margin-left:5px;visibility:hidden;}
#captchaResponse{width:292px;}
.prettyprint{border:none!important;background-color:#fff;padding:5px!important;display:inline-block;max-height:400px;overflow-x:auto;max-width:600px;margin:0;}
.embed{position:absolute;width:0px;height:0px;overflow:hidden;}
table.flashListing td.postblock{padding:5px;text-align:center;}
table.flashListing td{padding:2px;font-size:9pt;}
table.flashListing td:not(.subject){text-align:center;}
table.flashListing .name{color:#117743;font-weight:bold;}
table.flashListing .postertrip{color:#117743;}
table.flashListing .subject{color:#cc1105;font-weight:bold;}
table.flashListing tr:nth-of-type(odd){background-color:#e0e5f6;}
input[type="text"],input[type="password"],textarea{-webkit-appearance:none;-webkit-border-radius:0;}
.countryFlag{padding-top:1px;margin-bottom:-1px;}
iframe[src="about:blank"]{display:none;}
.deadlink{text-decoration:line-through;}
.oldpost{background:inherit;color:#0F0C5D;font-weight:800;}
#enable-mobile{font-size:small!important;}
#disable-mobile{font-size:small!important;}
.mFileInfo{padding-top:5px;text-align:center;color:#707070!important;font-size:9pt!important;text-decoration:none!important;}
.name-col{max-width:250px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-wrap:break-word;}
.ad-plea{margin-top:2px;text-align:center;font-size:smaller;}
.ad-plea a{text-decoration:none;}
.fileText a{text-decoration:underline;}
#search-box{height:16px;line-height:16px;margin-left:2px;padding:0 2px;width:120px;}
#blotter{width:468px;margin:auto;}
#blotter td{vertical-align:top;font-size:11px;}
.blotter-date{width:50px;text-align:center;}
#blotter tfoot{text-align:right;}
.redtxt{color:red;}
#postForm textarea{width:292px;}
#postForm{width:468px;display:none;}
#togglePostFormLink{font-size:22px;font-weight:bold;text-align:center;}
.fileWebm:hover:before{background-color:rgba(0,0,0,0.75);color:#FFF;font-weight:bold;line-height:18px;padding:0 3px 0 2px;position:absolute;content:'webm';display:block;font-size:11px;text-decoration:none;}
.expandedWebm{float:left;margin:3px 20px 5px;}
#tooltip{position:absolute;background-color:#181f24;font-size:11px;line-height:13px;padding:3px 6px;z-index:100000;word-wrap:break-word;white-space:pre-line;max-width:400px;color:#fff;text-align:center;}
.tip-top-left:before,.tip-top-right:before,.tip-top:before{content:"";display:block;width:0;height:0;position:absolute;border-left:4px solid transparent;border-right:4px solid transparent;border-top:4px solid #181f24;margin-left:-4px;bottom:-4px;}
.tip-top:before{left:50%;}
.tip-top-right:before{left:2px;margin-left:0;}
.tip-top-left:before{right:2px;}
#postFile{margin-right:10px;width:200px;}
.dd-menu{position:absolute;font-size:12px;line-height:1.3em;}
.dd-menu a{text-decoration:none;color:inherit!important;display:block;}
.dd-menu ul{background-color:#D6DAF0;border:1px solid #B7C5D9;border-right-width:2px;list-style:none;padding:0;margin:0;white-space:nowrap;}
.dd-menu ul ul{display:none;position:absolute;}
.dd-menu li{cursor:pointer;position:relative;padding:2px 4px;vertical-align:middle;border-bottom:1px solid #B7C5D9;}
.dd-menu li:hover{background-color:#EEF2FF;}
.dd-menu li:hover ul{display:block;left:100%;margin-top:-3px;}
.dd-menu.dd-menu-left li:hover ul{left:auto;right:100%;}
""".decode('utf-8')

HTML_TEMPLATE = Template("""
<html>
    <head>
        <style>
        ${STYLESHEET}
        </style>
        <script src="file://localhost${JQUERY}"></script>
        <script>
        $$(function() {
            var quotation = $$("#quotation");

            // Toggle thumbnail/full-size image on click
            $$("a.fileThumb img").click(function() {
                $$(this).width(  $$(this).hasClass("thumb") ? $$(this).data("width")  : $$(this).data("thumbWidth") );
                $$(this).height( $$(this).hasClass("thumb") ? $$(this).data("height") : $$(this).data("thumbHeight") );
                $$(this).toggleClass("thumb");
                return false; // disable link
            });

            // Show original post when hovering over link to post
            $$("a.quotelink").mouseover(function() {
              var quoteLink = $$(this);

              // make sure that the link points to a post in this thread
              if ( quoteLink.attr("href")[0] !== "#") { return; }

              quotation = $$( quoteLink.attr("href") ).clone();
              quotation.insertAfter( quoteLink );
              quotation.attr("id", "quotation");
              quotation.css("position", "absolute");
              quotation.css("border", "1px solid");
            });
            $$("a.quotelink").mouseout(function() {
              quotation.remove();
            });
        });
        </script>
    </head>
    <body>
        <form>
            <div class="board">
                <div class="thread" id="${THREADID}">
                    ${THREAD}
                </div>
            </div>
        </form>
    </body>
</html>
""".decode('utf-8'))

IMAGE_TEMPLATE = Template("""
<div class="file" id="f${POSTID}">
    <div class="fileText" id="fT${POSTID}">File: <a href="${TIM}${FILEEXT}" target="_blank">${FILENAME}.${FILEEXT}</a> (${FILESIZE}, ${WIDTH}x${HEIGHT})</div>
    <a class="fileThumb" href="${TIM}${FILEEXT}" target="_blank">
        <img src="${TIM}${FILEEXT}" class="thumb" style="height: ${THUMB_HEIGHT}px; width: ${THUMB_WIDTH}px;"
        data-thumb-width="${THUMB_WIDTH}"
        data-thumb-height="${THUMB_HEIGHT}"
        data-width="${WIDTH}"
        data-height="${HEIGHT}">
        <div data-tip="" data-tip-cb="mShowFull" class="mFileInfo mobile">${FILESIZE} ${FILEEXT}</div>
    </a>
</div>
""".decode("utf-8"))

POST_TEMPLATE = Template("""
<div class="postContainer replyContainer" id="pc${POSTID}">
    <div class="sideArrows" id="sa${POSTID}">&gt;&gt;</div>
    <div id="p${POSTID}" class="post reply">
        <div class="postInfo desktop" id="pi${POSTID}">
            <input type="checkbox" name="${POSTID}" value="delete">
            <span class="nameBlock">
                <span class="name">Anonymous</span>
            </span>
            <span class="dateTime" data-utc="${TIMESTAMP}" title="Timezone: UTC-5">${DATE}</span>
            <span class="postNum desktop">
                <a href="#p${POSTID}" title="Link to this post">No.</a>
                <a>${POSTID}</a>
            </span>
            <a href="#" class="postMenuBtn" title="Post menu" data-cmd="post-menu">▶</a>
        </div>
        ${IMAGE}
        <blockquote class="postMessage" id="m${POSTID}">${CONTENT}</blockquote>
    </div>
</div>
""".decode("utf-8"))

# Did we specify a JSON file?
if len(sys.argv) > 1 and sys.argv[1][-4:] == "json":
    JSON_LOC = os.expanduser("%s/%s" % (os.getcwd(), sys.argv[1]))
    if not os.exists(JSON_LOC):
        print "JSON file %s not found at %s" % (sys.argv[1], JSON_LOC)
        sys.exit(1)
else: # Find the json file in the current directory
    files = [ f for f in os.listdir(os.getcwd()) if f[-4:] == "json" and f[-11:] != "-fetch.json"]
    if len(files) == 1:
        JSON_LOC = "%s/%s" % (os.getcwd(), files[0])
    else:
        print "Multiple JSON files were found: %s" % (files)
        sys.exit(1)

print "Reading from %s" % JSON_LOC

HTML_FILE = codecs.open("%s/out.html" % os.path.dirname(JSON_LOC), 'w', encoding='utf-8')

try:
    JSON_FILE = codecs.open(JSON_LOC, 'r', encoding='utf-8')
except IOError as e:
    print "Unable to read JSON file: %s" % e
    sys.exit(2)

try:
    JSON = json.loads(JSON_FILE.read())
except e:
    print "Unable to read JSON contents: %s" % e
    sys.exit(2)


HTML = ""
for post in JSON['posts']:
    image = ''
    if post.has_key('filename'):
        image = IMAGE_TEMPLATE.substitute(POSTID = post['no'],
                                          TIM = post['tim'],
                                          FILENAME = post['filename'],
                                          FILEEXT = post['ext'],
                                          FILESIZE = post['fsize'],
                                          WIDTH = post['w'],
                                          HEIGHT = post['h'],
                                          THUMB_HEIGHT = post['tn_h'],
                                          THUMB_WIDTH = post['tn_w'])
    HTML = "%s%s" % (HTML, POST_TEMPLATE.substitute(POSTID = post['no'],
                                                    TIMESTAMP = post['time'],
                                                    DATE = post['now'],
                                                    IMAGE = image,
                                                    CONTENT = post.has_key('com') and post['com'] or ""))

HTML_FILE.write(HTML_TEMPLATE.substitute(THREADID = JSON['posts'][0]['no'],
                                         THREAD = HTML,
                                         STYLESHEET = STYLESHEET,
                                         JQUERY = JQUERY_LOC))
HTML_FILE.close()