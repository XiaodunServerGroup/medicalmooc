//The name of the plugin that the user will write in the html
window.CatchAnnotation = ("CatchAnnotation" in window) ? CatchAnnotation : {};
window.CatchSources = ("CatchSources" in window) ? CatchSources : {};


//    
//     HTML TEMPLATES
// 
CatchSources.HTMLTEMPLATES = function(root){
    var root = root || '';
    return {
//Main
annotationList:
    '<div class="annotationListButtons">'+
        '{{{ PublicPrivate }}}'+
    '</div>'+
    '<div class="annotationList">'+
        '{{{ MediaSelector }}}'+
        '<div class="header">'+
            '<div class="annotationRow">'+
                '<div class="expandableIcon field">'+
                    '&nbsp  <!-- TODO: better way to ensure width upon hide -->'+
                '</div>'+

                '<div class="annotatedBy field">'+
                    gettext("Username")+
                '</div>'+

                '<div class="body field">'+
                    gettext("Notes")+
                '</div>'+  
                
                '{{#if videoFormat}}'+
                    '<div class="start field">'+
                        'Start'+
                    '</div>'+

                    '<div class="end field">'+
                        'End'+
                    '</div>'+
                '{{/if}}'+
                
                '<div class="annotatedAt field">'+
                    gettext("Add notes time")+
                '</div>'+
            '</div>'+
        '</div>'+
        '{{#each annotationItems}}'+
            '{{{ this }}}'+
        '{{/each}}'+
    '</div>'+
    '<div class="annotationListButtons">'+
        '<div class="moreButtonCatch">More</div>'+
    '</div>',
    
//Main->PublicPrivate
annotationPublicPrivate:
    '<div class="selectors"><div class="PublicPrivate myNotes active">'+gettext("notes")+'<span class="action">myNotes</span></div>'+
    '<div class="PublicPrivate public">'+gettext("Public notes")+'<span class="action">public</span></div></div>'+
    '<div class="searchbox"><div class="searchinst">'+gettext("Search")+'</div><select class="dropdown-list">'+
    '<option value="Users">'+gettext("Username")+'</option>'+
    '<option value="text">'+gettext("Note Content")+'</option>'+
    '</select><input type="text" name="search"/><div class="search-icon" alt="Run search."></div></div>',
    
//Main->MediaSelector
annotationMediaSelector:
    '<ul class="ui-tabs-nav">'+
        '<li class="ui-state-default" media="text">'+
            'Text'+
        '</li>'+
        '<li class="ui-state-default" media="video">'+
            'Video'+
        '</li>'+
    '</ul>',
//    '<div class="selButtonCatch">Text<span class="action">text</span></div>'+
//    '<div class="selButtonCatch">Video<span class="action">video</span></div>',
//        '<div class="selButtonCatch">Images<span class="action">image</span></div>'+
//        '<div class="selButtonCatch">Audio<span class="action">audio</span></div>'+
//        '<div class="selButtonCatch">Maps<span class="action">map</span></div>'+
//        '<div class="selButtonCatch">3D studio<span class="action">3d</span></div>',

//Main->ContainerRow
annotationItem: 
    '<div class="annotationItem {{ evenOrOdd }} {{ openOrClosed }}" annotationId="{{ id }}">'+
        '{{{ annotationRow }}}'+
        '{{{ annotationDetail }}}'+
    '</div>',

//Main->ContainerRow->Reply
annotationReply: 
        //<blockquote style="font-size:90%"><p><em>On Sep 14, 2013 4:35 PM <a href="#">jharvard</a>, wrote from [<a href="#">show map location</a>]:</em></p><p>{{{ an.text }}}</p></blockquote>
    '{{#if annotations}}'+
        '{{#each annotations}}'+
            '<blockquote class="replyItem" annotationId="{{this.id}}" style="font-size:90%">'+
                '<p>'+
                    'On  {{ this.updated }} <!--<a href="index.php?r=user/user/view&id={{{this.user.id}}}">-->{{{ this.user.name }}}<!--</a>-->{{#if this.geolocation}}, wrote from {{/if}}'+
                    '{{#if geolocation}}'+
                    '<span class="geolocationIcon">'+
                        '<img src="'+root+'geolocation_icon.png"width="25" height="25" alt="Location Map" title="Show Location Map" data-dropdown="myLocationMap"/>'+
                        '<span class="idAnnotation" style="display:none">{{{ this.id }}}</span>'+
                        '<span class="latitude" style="display:none">{{{ this.geolocation.latitude }}}</span>'+
                        '<span class="longitude" style="display:none">{{{ this.geolocation.longitude }}}</span>'+
                    '</span>'+
                    '<div id="myLocationMap" data-dropdown-content class="f-dropdown content">'+
                        '<div class="map"></div>'+
                    '</div>'+
                    '{{/if}}'+
                    '<div class="deleteReply">Delete</div>'+
                '</p>'+
                '<p>'+
                    '{{#if this.text}}'+
                        '{{{this.text}}}'+
                     '{{else}}'+
                        '-'+
                    '{{/if}}'+
                '</p>'+
            '</blockquote>'+
        '{{/each}}'+
    '{{/if}}',

//Main->ContainerRow->Row
annotationRow:
    '<div class="annotationRow item">'+
        '<div class="expandableIcon field">'+
            '<img src="'+root+'expandableIcon.png" alt="View Details" />'+
            '&nbsp'+
        '</div>'+

        '<div class="annotatedBy field">'+
            '{{ username }}'+
        '</div>'+

        '<div class="body field">'+
            '{{#if plainText}}'+
                '{{deparagraph plainText}}'+
             '{{else}}'+
                '-'+
            '{{/if}}'+
        '</div>'+

        '<div class="start field">'+
            '{{ rangeTime.start }}'+
        '</div>'+

        '<div class="end field">'+
            '{{ rangeTime.end }}'+
        '</div>'+
        
        '<div class="totalreplies field">'+
            '{{ totalComments }}'+
        '</div>'+

        '<div class="annotatedAt field">'+
            '{{ updated }}'+
        '</div>'+
    '</div>',

//Main->ContainerRow->DetailRow
annotationDetail:
    '<div class="annotationDetail">'+
        '<div class="detailHeader">'+
            '<span class="closeDetailIcon">'+
                '<img src="'+root+'closeIcon.png" alt="Hide Details" />'+
            '</span>'+
            gettext("Update")+'  {{ updated }} <!--<a href="index.php?r=user/user/view&id={{{user.id}}}">-->{{{ user.name }}}<!--</a>-->{{#if geolocation}}, wrote from {{/if}}'+
            '{{#if geolocation}}'+
            '<span class="geolocationIcon">'+
                '<img src="'+root+'geolocation_icon.png"width="25" height="25" alt="Location Map" title="Show Location Map" data-dropdown="myLocationMap"/>'+
                '<span class="idAnnotation" style="display:none">{{{ id }}}</span>'+
                '<span class="latitude" style="display:none">{{{ geolocation.latitude }}}</span>'+
                '<span class="longitude" style="display:none">{{{ geolocation.longitude }}}</span>'+
            '</span>'+
            '<div id="myLocationMap" data-dropdown-content class="f-dropdown content">'+
                '<div class="map"></div>'+
            '</div>'+
            '{{/if}}'+
        '</div>'+

        '<div class="quote">'+
            '<div style="text-align: center">'+
            '<div class="quoteItem">“</div><div class="quoteText">{{{ quote }}}</div><div class="quoteItem">”</div></div>'+
            '<span class="idAnnotation" style="display:none">{{{ id }}}</span>'+
            '<span class="uri" style="display:none">{{{uri}}}</span>'+
        '</div>'+

        '<div class="body">'+
            '{{{ text }}}'+
        '</div>'+
        
        '<div class="controlReplies">'+
            '<div class="hideReplies" style="text-decoration:underline;display:{{#if hasReplies}}block{{else}}none{{/if}}">Show Replies</div>&nbsp;'+
            '{{#if authToEditButton}}'+
                '<div class="editAnnotation" style="text-decoration:underline">'+gettext("Edit")+'</div>'+
            '{{/if}}'+
            '{{#if authToDeleteButton}}'+
                '<div class="deleteAnnotation" style="text-decoration:underline">'+gettext("Delete")+'</div>'+
            '{{/if}}'+
            
        '</div>'+
        
        '<div class="replies"></div>'+
    '</div>',
    
//Main->ContainerRow->DetailRow (Video)
videoAnnotationDetail:
    '<div class="annotationDetail videoAnnotationDetail">'+
        '<div class="detailHeader">'+
            '<span class="closeDetailIcon">'+
                '<img src="'+root+'closeIcon.png" alt="Hide Details" />'+
            '</span>'+
            'On  {{ updated }} <!--<a href="index.php?r=user/user/view&id={{{user.id}}}">-->{{{ user.name }}}<!--</a>-->{{#if geolocation}}, wrote from {{/if}}'+
            '{{#if geolocation}}'+
                '<span class="geolocationIcon">'+
                    '<img src="'+root+'geolocation_icon.png"width="25" height="25" alt="Location Map" title="Show Location Map" data-dropdown="myLocationMap"/>'+
                    '<span class="idAnnotation" style="display:none">{{{ id }}}</span>'+
                    '<span class="latitude" style="display:none">{{{ geolocation.latitude }}}</span>'+
                    '<span class="longitude" style="display:none">{{{ geolocation.longitude }}}</span>'+
                '</span>'+
                '<div id="myLocationMap" data-dropdown-content class="f-dropdown content">'+
                    '<div class="map"></div>'+
                '</div>'+
            '{{/if}}'+
        '</div>'+

        '<div class="playMediaButton">'+
            'Play segment {{{ rangeTime.start }}} - {{{ rangeTime.end }}}'+
            '<span class="idAnnotation" style="display:none">{{{ id }}}</span>'+
            '<span class="uri" style="display:none">{{{uri}}}</span>'+
            '<span class="container" style="display:none">{{{target.container}}}</span>'+
        '</div>'+

        '<div class="body">'+
            '{{{ text }}}'+
        '</div>'+

        '<div class="controlReplies">'+
            '<div class="newReply" style="text-decoration:underline">Reply</div>&nbsp;'+
            '<div class="hideReplies" style="text-decoration:underline;display:{{#if hasReplies}}block{{else}}none{{/if}}">Show Replies</div>&nbsp;'+
            '{{#if authToEditButton}}'+
                '<div class="editAnnotation" style="text-decoration:underline">Edit</div>'+
            '{{/if}}'+
            '{{#if authToDeleteButton}}'+
                '<div class="deleteAnnotation" style="text-decoration:underline">Delete</div>'+
            '{{/if}}'+
        '</div>'+
        
        '<div class="replies"></div>'+
        
        
    '{{#if tags}}'+
        '<div class="tags">'+
            '<h3>Tags:</h3>'+
            '{{#each tags}}'+
                '<div class="tag">'+
                    '{{this}}'+
                '</div>'+
            '{{/each}}'+
        '</div>'+
    '{{/if}}'+

        '<div class="controlPanel">'+
            //'<img class="privacy_button" src="'+root+'privacy_icon.png" width="36" height="36" alt="Privacy Settings" title="Privacy Settings">'+
//            '<img class="groups_button" src="'+root+'groups_icon.png" width="36" height="36" alt="Groups Access" title="Groups Access">'+
//            '<img class="reply_button" src="'+root+'groups_icon.png" width="36" height="36" alt="Reply" title="Reply" idAnnotation="{{{ id }}}">'+
            //'<img class="share_button" src="'+root+'share_icon.png" width="36" height="36" alt="Share Annotation" title="Share Annotation"/>'+
        '</div>'+
    '</div>',
};
};



CatchAnnotation = function (element, options) {
    //local variables
    var $ = jQuery,
        options = options || {};

    //Options
    var defaultOptions = {
        media: 'text',
        userId: '', //this is an integer and its value is the userId to see user annotations
        externalLink: false,//This is true if you want to open the link in a new URL. However, it is false if you want to open the url in the same page
        showMediaSelector: true, //whether show the selector of Media Annotations or not
        showPublicPrivate: true, //Whether show Public or Private Annotation Selector
        pagination: 50, //Number of Annotations per load in the pagination
        flags:false //This checks to see if user is staff and has access to see flags
    };
    this.options = $.extend( true, defaultOptions, options );
    
    //element
    this.element = element;
    
    //clean boolean
    this.clean = false;
    
    //Reset element an create a new element div
    element.html('<div id="mainCatch" class="annotationListContainer"></div>');
    
    //INIT
    var self = this;
    $( document ).ready(function() {
        self.init();
        self.refreshCatch(true);
    	var moreBut = self.element.find('.annotationListButtons .moreButtonCatch');
    	moreBut.hide();	
    });
    
    return this;
}

CatchAnnotation.prototype = {
    init: function(){
        //Set variables
        //Initial Templates
        this.TEMPLATENAMES = [
            "annotationList", //Main
            "annotationPublicPrivate", //Main->PublicPrivate
            "annotationMediaSelector", //Main->MediaSelector
            "annotationItem", //Main->ContainerRow
            "annotationReply",//Main->ContainerRow->Reply
            "annotationRow", //Main->ContainerRow->Row
            "annotationDetail",//Main->ContainerRow->DetailRow
            "videoAnnotationDetail"//Main->ContainerRow->DetailRow (Video)
        ];
        //annotator
        var wrapper = $('.annotator-wrapper').parent()[0],
            annotator = $.data(wrapper, 'annotator');
        this.annotator = annotator;
        
        //Subscribe to annotator
        this._subscribeAnnotator();
        
        //    
        //    Handlebars Register Library
        //
        Handlebars.registerHelper('deparagraph', function(txt) {
            var dpg = txt.replace("<p>", "").replace("</p>", "");
            return dpg;
        });
        
        //Compile templates
        this.HTMLTEMPLATES = CatchSources.HTMLTEMPLATES(this.options.imageUrlRoot);
        this.TEMPLATES = {};
        this._compileTemplates();
    },
    //    
    //     GLOBAL UTILITIES
    // 
    refreshCatch: function(newInstance) {
        var mediaType = this.options.media || 'text',
            annotationItems = [],
            index = 0,
            annotations = this.annotator.plugins['Store'].annotations || [],
            el = $("#mainCatch.annotationListContainer"),
            self = this,
            newInstance = newInstance || false;
        annotations.forEach(function(annotation) {
            var isMedia = annotation.media==self.options.media,
                isUser = (typeof self.options.userId!='undefined' && self.options.userId!='' && self.options.userId!=null)?
                    self.options.userId == annotation.user_id:true,
                isInList = newInstance?false:self._isInList(annotation);
            if (isMedia && isUser && !isInList){
                var item = jQuery.extend(true, {}, annotation);
                self._formatCatch(item);
                
                //Authorized
                var permissions = self.annotator.plugins.Permissions,
                    authorized = permissions.options.userAuthorize('delete', annotation,permissions.user),
                    updateAuthorized = permissions.options.userAuthorize('update', annotation,permissions.user);
                
                item.authToDeleteButton = authorized;
                item.authToEditButton = updateAuthorized;
                item.hasReplies = (item.totalComments > 0);

                var html = self.TEMPLATES.annotationItem({
                    item: item,
                    id: item.id,
                    evenOrOdd: index % 2 ? "odd" : "even",
                    openOrClosed: "closed",
                    annotationRow: self.TEMPLATES.annotationRow(item),
                    annotationDetail: (mediaType === "video") ? self.TEMPLATES.videoAnnotationDetail(item):self.TEMPLATES.annotationDetail(item),
                });
                index++;
                /*
                annotationItem: 
                    '<div class="annotationItem {{ evenOrOdd }} {{ openOrClosed }}" annotationId="{{ id }}">'+
                        '{{{ annotationRow }}}'+
                        '{{{ annotationDetail }}}'+
                    '</div>',
                */
                annotationItems.push(html);
            }
        });
        
        if (newInstance){
            var videoFormat = (mediaType === "video") ? true:false;
            el.html(self.TEMPLATES.annotationList({ 
                annotationItems: annotationItems, 
                videoFormat: videoFormat,
                PublicPrivate: self.options.showPublicPrivate?self.TEMPLATES.annotationPublicPrivate():'',
                MediaSelector: self.options.showMediaSelector?self.TEMPLATES.annotationMediaSelector():'',
            }));
        }else{
            var list = $("#mainCatch .annotationList");
            annotationItems.forEach(function(annotation) {
                list.append($(annotation));
            });
        }
        
        //Set SelButtons to media
        var SelButtons = el.find('.annotationList li').removeClass('active'); //reset
        for (var index=0;index<SelButtons.length;index++) {
            var span = $(SelButtons[index]);
            if (span.attr("media")==this.options.media) $(SelButtons[index]).addClass('active');
        }
        //Set PublicPrivate
        var PublicPrivateButtons = el.find('.annotationListButtons .PublicPrivate').removeClass('active'); //reset
        for (var index=0;index<PublicPrivateButtons.length;index++) {
            var span = $(PublicPrivateButtons[index]).find('span'),
                isUser = (typeof self.options.userId!='undefined' && self.options.userId!='' && self.options.userId!=null);
            if (isUser && span.html()=="myNotes") $(PublicPrivateButtons[index]).addClass('active');
            else if (!isUser && span.html()=="public") $(PublicPrivateButtons[index]).addClass('active');
        }
        
        //reset all old events
        el.off();
        
        //Bind functions
        var openAnnotationItem = this.__bind(this._openAnnotationItem,this),
	    closeAnnotationItem = this.__bind(this._closeAnnotationItem,this),
            onGeolocationClick = this.__bind(this._onGeolocationClick,this),
            onPlaySelectionClick = this.__bind(this._onPlaySelectionClick,this),
            onShareControlsClick = this.__bind(this._onShareControlsClick,this),
            onSelectionButtonClick = this.__bind(this._onSelectionButtonClick,this),
            onPublicPrivateButtonClick = this.__bind(this._onPublicPrivateButtonClick,this),
            onQuoteMediaButton = this.__bind(this._onQuoteMediaButton,this),
            onControlRepliesClick = this.__bind(this._onControlRepliesClick,this),
            onMoreButtonClick = this.__bind(this._onMoreButtonClick,this),
            onSearchButtonClick = this.__bind(this._onSearchButtonClick, this),
            onDeleteReplyButtonClick = this.__bind(this._onDeleteReplyButtonClick,this);
    
        //Open Button
        el.on("click", ".annotationItem .annotationRow", openAnnotationItem);
        //Close Button
        el.on("click", ".annotationItem .detailHeader", closeAnnotationItem);
        //Geolocation button
        el.on("click",".annotationItem .detailHeader .geolocationIcon img", onGeolocationClick);
        //controlPanel buttons
        el.on("click",".annotationItem .annotationDetail .controlPanel", onShareControlsClick);
        //VIDEO
        if (this.options.media=='video') {
            //PlaySelection button
            el.on("click",".annotationItem .annotationDetail .playMediaButton", onPlaySelectionClick);
        }
        //TEXT
        if (this.options.media=='text') {
            //PlaySelection button
            el.on("click",".annotationItem .annotationDetail .quote", onQuoteMediaButton);
        }
        
        //controlReplies
        el.on("click",".annotationItem .controlReplies", onControlRepliesClick);
        
        //Selection Buttons
        el.on("click",".annotationList li", onSelectionButtonClick);
        //PublicPrivate Buttons
        el.on("click",".annotationListButtons .PublicPrivate", onPublicPrivateButtonClick);
        //More Button
        el.on("click",".annotationListButtons .moreButtonCatch", onMoreButtonClick);
        
        //Search Button
        el.on("click",".searchbox .search-icon", onSearchButtonClick);
        
        //Delete Reply Button
        el.on("click", ".replies .replyItem .deleteReply", onDeleteReplyButtonClick);      
    },
    changeMedia: function(media) {
        var media = media || 'text';
        this.options.media = media;
    	this._refresh();
        this.refreshCatch(true);
    	this.checkTotAnnotations();
    },
    changeUserId: function(userId) {
        var userId = userId || '';
        this.options.userId = userId;
        this._refresh();
        this.refreshCatch(true);
        this.checkTotAnnotations();
    },
    loadAnnotations: function() {
        var annotator = this.annotator,
            loadFromSearch = annotator.plugins.Store.options.loadFromSearch,
            loadedAn = this.element.find('.annotationList .annotationItem').length;
        loadedAn = typeof loadedAn!='undefined' ?loadedAn:0;
        
        loadFromSearch.limit = this.options.pagination;
        loadFromSearch.offset = loadedAn;
        loadFromSearch.media = this.options.media;
        loadFromSearch.userid = this.options.userId;
        
        // Dani had this for some reason. we can't remember. but if something
        // breaks, uncomment next line.
        //annotator.plugins['Store'].loadAnnotationsFromSearch(loadFromSearch);
        
        //Make sure to be openned all annotations for this pagination
    	loadFromSearch.limit = this.options.pagination+loadedAn;
    	loadFromSearch.offset = 0;
    	annotator.plugins['Store'].loadAnnotationsFromSearch(loadFromSearch);
        
        //text loading annotations
        var moreBut = this.element.find('.annotationListButtons .moreButtonCatch');
        moreBut.html('Please wait, loading...');
    },
            
    //check whether is necessary more button or not
    checkTotAnnotations: function(){
        var annotator = this.annotator,
            loadFromSearch = annotator.plugins.Store.options.loadFromSearch,
            oldLimit = loadFromSearch.limit,
            oldOffset = loadFromSearch.offset,
            self = this;
            
        loadFromSearch.limit = 0;
        loadFromSearch.offset = 0;
        loadFromSearch.media = this.options.media;
        loadFromSearch.userid = this.options.userId;
        var onSuccess = function(response){
            var totAn = self.element.find('.annotationList .annotationItem').length,
                maxAn = response.total,
                moreBut = self.element.find('.annotationListButtons .moreButtonCatch');
            if (totAn<maxAn && totAn > 0)
                moreBut.show();
            else
                moreBut.hide();
        }
        
        var obj = loadFromSearch,
            action = 'search';
    
        var id, options, url;
        id = obj && obj.id;
        url = annotator.plugins['Store']._urlFor(action, id);
        options = annotator.plugins['Store']._apiRequestOptions(action, obj, onSuccess);
        $.ajax(url, options);
        
        //reset values
        loadFromSearch.limit = oldLimit;
        loadFromSearch.offset = oldOffset;
        
        //set More button text
        var moreBut = this.element.find('.annotationListButtons .moreButtonCatch');
        moreBut.html('More');
        
        //setTimeout();
    },

    //    
    //     LOCAL UTILITIES
    // 
    _subscribeAnnotator: function(){
        var self = this,
            annotator = this.annotator;
        //Subscribe to Annotator changes
        annotator.subscribe("annotationsLoaded", function (annotations){
            self.refreshCatch(self.clean);
            //hide or show more button
            self.checkTotAnnotations();
        });
        annotator.subscribe("annotationUpdated", function (annotation){
            self.refreshCatch(true);
            self.checkTotAnnotations();
        });
        annotator.subscribe("annotationDeleted", function (annotation){
            var annotations = annotator.plugins['Store'].annotations,
                tot = typeof annotations !='undefined'?annotations.length:0,
                attempts = 0; // max 100
            //This is to watch the annotations object, to see when is deleted the annotation
            var ischanged = function(){
                var new_tot = annotator.plugins['Store'].annotations.length;
                if (attempts<100)
                    setTimeout(function(){
                        if (new_tot != tot){
                            self.refreshCatch(true);
			    self.checkTotAnnotations();
                        }else{
                            attempts++;
                            ischanged();
                        }
                    },100); //wait for the change in the annotations
            };
            ischanged();
        });
        annotator.subscribe("annotationCreated", function (annotation){
            var attempts = 0; // max 100
            //wait to get an annotation id
            var ischanged = function(){
                if (attempts<100)
                    setTimeout(function(){
                        if (typeof annotation.id!='undefined'){
                            self.refreshCatch();
                            if (typeof annotation.parent != 'undefined' && annotation.parent != '0'){
                                var replies = $("[annotationid="+annotation.parent+"]").find(".controlReplies .hideReplies");
				replies.show();
                                replies.click();
                                replies.click();
                            }
                        }else{
                            attempts++;
                            ischanged();
                        }
                    },100); //wait for annotation id
            };
            ischanged();
        });
    },
    __bind: function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    _compileTemplates: function() {
    	var self = this;
        //Change the html tags to functions 
        this.TEMPLATENAMES.forEach(function(templateName) {
            self.TEMPLATES[templateName] = Handlebars.compile(self.HTMLTEMPLATES[templateName]);
        });
    },
    _isVideoJS: function (an){
        var annotator = this.annotator,
            rt = an.rangeTime,
            isOpenVideojs = (typeof annotator.mplayer != 'undefined'),
            isVideo = (typeof an.media!='undefined' && an.media=='video'),
            isNumber = (typeof rt!='undefined' && !isNaN(parseFloat(rt.start)) && isFinite(rt.start) && !isNaN(parseFloat(rt.end)) && isFinite(rt.end));
        return (isOpenVideojs && isVideo && isNumber);
    },
    _isInList: function (an){
        var annotator = this.annotator,
            isInList = false,
            list = $('#mainCatch .annotationList .annotationRow.item');
        for (_i = 0, _len = list.length; _i < _len; _i++) {
             if ($(list[_i]).parent().attr('annotationid') == an.id)
                  isInList = true;
        }
        return isInList;
    },
    _formatTime: function(dtime) {
        var regexp = "([0-9]{4})-([0-9]{2})-([0-9]{2})\\s+([0-9]{2}):([0-9]{2}):([0-9]{2})"
        var d = dtime.match(regexp);

        if (!d) {
            regexp = "([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})";
            d = dtime.match(regexp);
        }

        formatstr = ""
        if (d && d[0]) {
            formatstr = d[1] + "年" + d[2] + "月" + d[3] + "日"

            if (d[4] && d[5] && d[6]) {
                formatstr += (" " +[d[4], d[5], d[6]].join(':'))
            }
        } else {
            formatstr = "无法确定"
        }

        return formatstr
    },
    _formatCatch: function(item) {
        var item = item || {};
        
        if(this._isVideoJS(item)){
            //format time
            item.rangeTime.start= typeof vjs!='undefined'?vjs.formatTime(item.rangeTime.start):item.rangeTime.start;
            item.rangeTime.end= typeof vjs!='undefined'?vjs.formatTime(item.rangeTime.end):item.rangeTime.end;
        }
        //format date
        /*
        if(typeof item.updated!='undefined' && typeof createDateFromISO8601!='undefined')
            item.updated = createDateFromISO8601(item.updated);
        */

        if (typeof item.updated!='undefined') {
            item.updated = this._formatTime(item.updated)
        }
        //format geolocation
        if(typeof item.geolocation!='undefined' && (typeof item.geolocation.latitude=='undefined'||item.geolocation.latitude==''))
            delete item.geolocation;
        
        /* NEW VARIABLES */
        //set plainText for Catch
        item.plainText = item.text.replace(/&(lt|gt);/g, function (strMatch, p1){
            return (p1 == "lt")? "<" : ">";
        });//Change to < and > tags
        item.plainText = item.plainText.replace(/<\/?[^>]+(>|$)/g, "").replace('&nbsp;',''); //remove all the html tags
        
        //Flags
        if(!this.options.flags && typeof item.tags != 'undefined' && item.tags.length > 0){
            for(var len=item.tags.length, index = len-1; index >= 0; --index){
                var currTag = item.tags[index];
                if(currTag.indexOf("flagged-") != -1){
                    
                    item.tags.splice(index);
                }
            }
        }
    },
    
    //    
    //     EVENT HANDLER
    // 
    _openAnnotationItem: function(evt) {
        var isClosed = $(evt.currentTarget).closest(".annotationItem").hasClass("closed");
        if (isClosed) {
            $(evt.currentTarget).closest(".annotationItem").removeClass("closed").addClass("open");
            //Add Share button
            var shareControl = $(evt.currentTarget).closest(".annotationItem").find('.annotationDetail .controlPanel:first'),
                annotator = this.annotator,
                idAnnotation = shareControl.parent().find('.idAnnotation').html(),
                uri = shareControl.parent().find('.uri').html();
            //remove the last share container
            shareControl.find('.share-container-annotator').remove();
            shareControl.append(annotator.plugins.Share.buildHTMLShareButton("",idAnnotation));
            //Set actions button
            annotator.plugins.Share.buttonsActions(shareControl[0],1,uri);
        } else {
            $(evt.currentTarget).closest(".annotationItem").removeClass("open").addClass("closed");
        }
    },
    _closeAnnotationItem: function(evt) {
        var existEvent = typeof evt.target!='undefined' && typeof evt.target.localName!='undefined';
        if(existEvent && evt.target.parentNode.className!='geolocationIcon'){
            this._openAnnotationItem(evt);
        }
    },
    _onGeolocationClick: function(evt) {
        var latitude = $(evt.target).parent().find('.latitude').html(),
            longitude = $(evt.target).parent().find('.longitude').html();
        var imgSrc = '<img src="http://maps.googleapis.com/maps/api/staticmap?center='+latitude+','+longitude+'&zoom=14&size=500x500&sensor=false&markers=color:green%7Clabel:G%7C'+latitude+','+longitude+'">';
        $(evt.target).parents('.detailHeader:first').find('#myLocationMap .map').html(imgSrc);
    },
    _onPlaySelectionClick: function(evt) {
        var id = $(evt.target).find('.idAnnotation').html(),
            uri = $(evt.target).find('.uri').html();
            container = $(evt.target).find('.container').html();
        if(this.options.externalLink){
            uri += (uri.indexOf('?') >= 0)?'&ovaId='+id:'?ovaId='+id;
            location.href = uri;
        }else{
            var isContainer = typeof this.annotator.an!='undefined' && typeof this.annotator.an[container]!='undefined',
                ovaInstance = isContainer? this.annotator.an[container]:null;
            if(ovaInstance!=null){
                var allannotations = this.annotator.plugins['Store'].annotations,
                    ovaId = id,
                    player = ovaInstance.player;

                for (var item in allannotations) {
                    var an = allannotations[item];
                    if (typeof an.id!='undefined' && an.id == ovaId){//this is the annotation
                        if(this._isVideoJS(an)){//It is a video
                            if (player.id_ == an.target.container && player.tech.options_.source.src == an.target.src){
                                var anFound = an;

                                var playFunction = function(){
                                    //Fix problem with youtube videos in the first play. The plugin don't have this trigger
                                    if (player.techName == 'Youtube'){
                                        var startAPI = function(){
                                            ovaInstance.showAnnotation(anFound);
                                        }
                                        if (ovaInstance.loaded)
                                            startAPI();
                                        else
                                            player.one('loadedRangeSlider', startAPI);//show Annotations once the RangeSlider is loaded
                                    }else{
                                        ovaInstance.showAnnotation(anFound);
                                    }

                                    $('html,body').animate({
                                        scrollTop: $("#"+player.id_).offset().top},
                                        'slow');
                                };
                                if (player.paused()) {
                                    player.play();
                                    player.one('playing',playFunction);
                                }else{
                                    playFunction();
                                }

                                return false;//this will stop the code to not set a new player.one.
                            }
                        }
                    }
                }
            }
        }
    },
    _onQuoteMediaButton: function(evt){
        var quote = $(evt.target).hasClass('quote')?$(evt.target):$(evt.target).parents('.quote:first'),
            id = quote.find('.idAnnotation').html(),
            uri = quote.find('.uri').html();
        if (typeof id=='undefined' || id==''){
            this.refreshCatch();
            this.checkTotAnnotations();
            id = quote.find('.idAnnotation').html();
            //clickPlaySelection(evt);
        }
        if(this.options.externalLink){
            uri += (uri.indexOf('?') >= 0)?'&ovaId='+id:'?ovaId='+id;
            location.href = uri;
        }else{
            var allannotations = this.annotator.plugins['Store'].annotations,
                ovaId = id;
            for (var item in allannotations) {
                var an = allannotations[item];
                if (typeof an.id!='undefined' && an.id == ovaId){//this is the annotation
                    if(!this._isVideoJS(an)){

                        var hasRanges = typeof an.ranges!='undefined' && typeof an.ranges[0] !='undefined',
                            startOffset = hasRanges?an.ranges[0].startOffset:'',
                            endOffset = hasRanges?an.ranges[0].endOffset:'';

                        if(typeof startOffset!='undefined' && typeof endOffset!='undefined'){ 

                            $(an.highlights).parent().find('.annotator-hl').removeClass('api'); 
                            //change the color
                            $(an.highlights).addClass('api'); 
                            //animate to the annotation
                            $('html,body').animate({
                                scrollTop: $(an.highlights[0]).offset().top},
                                'slow');
                        }
                    }
                }
            }
        }
    },
    _refreshReplies: function(evt){
        var item = $(evt.target).parents('.annotationItem:first'),
                anId = item.attr('annotationId');
            
            var replyElem = $(evt.target).parents('.annotationItem:first').find('.replies');
        var annotator = this.annotator,
                loadFromSearchURI = annotator.plugins.Store.options.loadFromSearch.uri,
                self = this,
                action='search',
                loadFromSearch={
                    limit:-1,
                    parentid:anId,
                    uri:loadFromSearchURI,        
                },
                onSuccess=function(data){
                    if (data == null) data = {};
                    annotations = data.rows || [];
                    var _i,_len;
                    for (_i = 0, _len = annotations.length; _i < _len; _i++) {
                        
                        self._formatCatch(annotations[_i]);
                    }
                    replyElem.html(self.TEMPLATES.annotationReply({ 
                        annotations: annotations
                    }));
                    var replyItems = $('.replies .replyItem');
                    if(typeof replyItems != 'undefined' && replyItems.length > 0){
                        annotations.forEach(function(ann){
                            replyItems.each(function(item){
                                var id = $(replyItems[item]).attr('annotationid');
                                if(id == ann.id){
                                    var perm = self.annotator.plugins.Permissions;
                                    if(!perm.options.userAuthorize('delete',ann,perm.user)){
                                        $(replyItems[item]).find('.deleteReply').remove();
                                    }else{
                                        $(replyItems[item]).data('annotation',ann);
                                        
                                    }
                                }
                            });
                        });
                    }
                };
            var id, options, request, url,
                store = this.annotator.plugins.Store;
            id = loadFromSearch && loadFromSearch.id;
            url = store._urlFor(action, id);
            options = store._apiRequestOptions(action, loadFromSearch, onSuccess);
            request = $.ajax(url, options);
            request._id = id;
            request._action = action;
    },
    _onControlRepliesClick: function(evt){
        var action = $(evt.target)[0].className;
        
        if(action=='newReply'){
            var item = $(evt.target).parents('.annotationItem:first'),
                id = item.attr('annotationId');
            //Pre-show Adder
            this.annotator.adder.show();
            
            //Get elements
            var replyElem = $(evt.target).parents('.annotationItem:first').find('.annotationDetail'),
                adder =this.annotator.adder,
                wrapper = $('.annotator-wrapper');

            //Calculate Editor position
            var positionLeft = videojs.findPosition($(evt.target).parent().find('.newReply')[0]),
                positionAnnotator = videojs.findPosition(wrapper[0]),
                positionAdder = {};

            positionAdder.left = positionLeft.left - positionAnnotator.left;
            positionAdder.top = positionLeft.top + 20 - positionAnnotator.top;

            adder.css(positionAdder);

            //Open a new annotator dialog
            this.annotator.onAdderClick();
            
            //Set vertical editor
            this.annotator.editor.resetOrientation();
            this.annotator.editor.invertY();
            this.annotator.editor.element.find('.annotator-widget').css('min-width',replyElem.css('width'));

            //set parent 
            var parentValue = $(this.annotator.editor.element).find(".reply-item span.parent-annotation");
            parentValue.html(id);
            var self = this;
            
        }else if(action=='hideReplies'){
            var oldAction = $(evt.target).html();
            
            if (oldAction=='Show Replies'){
                $(evt.target).html('Hide Replies');
            }else{
                $(evt.target).html('Show Replies');
                var replyElem = $(evt.target).parents('.annotationItem:first').find('.replies');
                replyElem.html('');
                return false;
            }
           
            //search
            this._refreshReplies(evt);
        }else if(action=='deleteAnnotation'){
            if(confirm("Would you like to delete the annotation?")){
                var annotator = this.annotator,
                        item = $(evt.target).parents('.annotationItem:first'),
                        id = item.attr('annotationId'),
                        store = annotator.plugins.Store,
                        annotations = store.annotations,
                        permissions = annotator.plugins.Permissions;
                var annotation;
                annotations.forEach(function(ann){
                   if(ann.id == id)
                       annotation = ann;
                });
                var authorized = permissions.options.userAuthorize('delete', annotation,permissions.user);
                if(authorized)
                    annotator.deleteAnnotation(annotation);
            }
        }else if(action=='editAnnotation'){
           
            var annotator = this.annotator,
                    item = $(evt.target).parents('.annotationItem:first'),
                    id = item.attr('annotationId'),
                    store = annotator.plugins.Store,
                    annotations = store.annotations,
                    permissions = annotator.plugins.Permissions;
            var annotation;
            annotations.forEach(function(ann){
               if(ann.id == id)
                   annotation = ann;
            });
            var authorized = permissions.options.userAuthorize('update', annotation,permissions.user);
            if(authorized){
                 //Get elements
                var wrapper = $('.annotator-wrapper');
                //Calculate Editor position
                    var positionLeft = videojs.findPosition($(evt.target).parent().find('.editAnnotation')[0]),
                    positionAnnotator = videojs.findPosition(wrapper[0]),
                    positionAdder = {};

                positionAdder.left = positionLeft.left - positionAnnotator.left;
                positionAdder.top = positionLeft.top + 20 - positionAnnotator.top;
                var cleanup, offset, update,
                  _this = this.annotator;
                offset = positionAdder;
                update = function() {
                  cleanup();
                  return _this.updateAnnotation(annotation);
                };
                cleanup = function() {
                  _this.unsubscribe('annotationEditorHidden', cleanup);
                  return _this.unsubscribe('annotationEditorSubmit', update);
                };
                this.annotator.subscribe('annotationEditorHidden', cleanup);
                this.annotator.subscribe('annotationEditorSubmit', update);
                this.annotator.viewer.hide();
                this.annotator.showEditor(annotation, offset);                
            }
        }
    },
    _onShareControlsClick: function(evt) {
        var action = $(evt.target)[0].className;
        //TODO- Decide whether privacy or group button
        if(action=='privacy_button'){
            //location.href = "index.php?r=video/privacy&id="+videoId;
            
        }else if(action=='groups_button'){
            alert("Coming soon...");
        }else if(action=='reply_button'){
            var item = $(evt.target).parents('.annotationItem:first'),
                id = item.attr('annotationId');
            //New annotation
            var an = this.annotator.setupAnnotation(this.annotator.createAnnotation());
            an.text="010";
            an.parent = id;
            //Store the annotation
            //this.annotator.plugins.Store.annotationCreated(an);
        }else if(action=='share_button'){
           

        }
    },
    _onPublicPrivateButtonClick: function(evt) {
        var action = $(evt.target).find('span'),
            userId = '';
    
        //Get userI
         userId = (action.html()=="myNotes")? this.annotator.plugins.Permissions.user.id : '';
        
        //Change userid and refresh
        this.changeUserId(userId);
    },
    _onSelectionButtonClick: function(evt){
        var but = $(evt.target),
            action = but.attr('media');
    
        //Get action
        if (action.length<=0) action="text"; //By default
        
        
        //Change media and refresh
        this.changeMedia(action);
    },
    _onMoreButtonClick: function(evt){
        this.clean = false;
        var moreBut = this.element.find('.annotationListButtons .moreButtonCatch'),
            isLoading = moreBut.html()=='More'?false:true;
        if(!isLoading)
            this.loadAnnotations();
    },
            
    _refresh:function(searchtype,searchInput){
        var searchtype = searchtype || "",
        searchInput = searchInput || ""; 
         this.clean = true;
        this._clearAnnotator();
        
        var annotator = this.annotator,
            loadFromSearch = annotator.plugins.Store.options.loadFromSearch;
        
        loadFromSearch.limit = this.options.pagination;
        loadFromSearch.offset = 0;
        loadFromSearch.media = this.options.media;
        loadFromSearch.userid = this.options.userId;
        
        loadFromSearch.username = "";
        loadFromSearch.tag = "";
        loadFromSearch.text = "";
        
        if (searchtype == "Users"){
            loadFromSearch.username = searchInput;
        } else if(searchtype == "Tags"){
            loadFromSearch.tag = searchInput;
        } else{
            loadFromSearch.text = searchInput;
        }
        annotator.plugins['Store'].loadAnnotationsFromSearch(loadFromSearch);
    },
    
    _onSearchButtonClick: function(evt){
        var searchtype = this.element.find('.searchbox .dropdown-list').val();
        var searchInput = this.element.find('.searchbox input').val();
        this._refresh(searchtype,searchInput);    
    },
    _clearAnnotator: function(){
        var annotator = this.annotator,
            store = annotator.plugins.Store,
            annotations = store.annotations.slice();
        
        annotations.forEach(function(ann){
            var child, h, _i, _len, _ref;
            if (ann.highlights != null) {
              _ref = ann.highlights;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                h = _ref[_i];
                if (!(h.parentNode != null)) {
                  continue;
                }
                child = h.childNodes[0];
                $(h).replaceWith(h.childNodes);
              }
            }
            store.unregisterAnnotation(ann);
        });
            
    },
    _onDeleteReplyButtonClick : function(evt){
        var annotator = this.annotator,
                    item = $(evt.target).parents('.replyItem:first'),
                    id = item.attr('annotationid'),
                    permissions = annotator.plugins.Permissions,
                    annotation = item.data('annotation');
        var authorized = permissions.options.userAuthorize('delete', annotation,permissions.user);
        if(authorized){
            //annotator.deleteAnnotation(annotation);
            if(confirm('Would you like to delete this reply?')){
              annotator.plugins['Store']._apiRequest('destroy', annotation, function(){});
              item.remove();
          }
        }
    }
}


