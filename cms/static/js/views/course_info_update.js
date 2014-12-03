define(["js/views/baseview", "underscore", "codemirror", "js/models/course_update",
    "js/views/feedback_prompt", "js/views/feedback_notification", "js/views/course_info_helper", "js/utils/modal"],
    function(BaseView, _, CodeMirror, CourseUpdateModel, PromptView, NotificationView, CourseInfoHelper, ModalUtils) {

    var CourseInfoUpdateView = BaseView.extend({
        // collection is CourseUpdateCollection
        events: {
            "click .new-update-button" : "onNew",
            "click #course-update-view .save-button" : "onSave",
            "click #course-update-view .cancel-button" : "onCancel",
            "click .post-actions > .edit-button" : "onEdit",
            "click .post-actions > .delete-button" : "onDelete"
        },

        initialize: function() {
            this.template = _.template($("#course_info_update-tpl").text());
            this.render();
            // when the client refetches the updates as a whole, re-render them
            this.listenTo(this.collection, 'reset', this.render);
        },

        render: function () {
            // iterate over updates and create views for each using the template
            var updateEle = this.$el.find("#course-update-list");
            // remove and then add all children
            $(updateEle).empty();
            var self = this;
            this.collection.each(function (update) {
                try {
                    CourseInfoHelper.changeContentToPreview(
                        update, 'content', self.options['base_asset_url']);
                    var newEle = self.template({ updateModel : update });
                    $(updateEle).append(newEle);
                } catch (e) {
                    // ignore
                }
            });
            this.$el.find(".new-update-form").hide();
            this.$el.find('.date').datepicker({ 'dateFormat': 'yy年mm月dd日' });
            return this;
        },

        onNew: function(event) {
            event.preventDefault();
            var self = this;
            // create new obj, insert into collection, and render this one ele overriding the hidden attr
            var newModel = new CourseUpdateModel();
            this.collection.add(newModel, {at : 0});

            var $newForm = $(this.template({ updateModel : newModel }));

            var updateEle = this.$el.find("#course-update-list");
            $(updateEle).prepend($newForm);

            var $textArea = $newForm.find(".new-update-content").first();
            //this.$codeMirror = CodeMirror.fromTextArea($textArea.get(0), {
           //     mode: "text/html",
           //     lineNumbers: true,
           //     lineWrapping: true
           // });

            $newForm.addClass('editing');
            this.$currentPost = $newForm.closest('li');

            // Variable stored for unit test.
            this.$modalCover = ModalUtils.showModalCover(false, function() {
                self.closeEditor(true)
            });

            $('.date').datepicker('destroy');
            $('.date').datepicker({ 'dateFormat': 'yy年mm月dd日' });
            
            this.textarea_id = $textArea.attr('id');
            tinymce.init({
                selector: "textarea#"+$textArea.attr('id'),
                theme: "modern",
                language_url: tinymce_language_url,
                plugins: [
                    "advlist autolink lists link image charmap print preview hr anchor pagebreak",
                    "searchreplace  visualblocks visualchars code",
                    "insertdatetime media nonbreaking save table contextmenu directionality",
                    "emoticons paste textcolor colorpicker textpattern"
                ],
                toolbar1: "insertfile undo redo | styleselect fontselect fontsizeselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media | forecolor backcolor",
                font_formats:"宋体=宋体;黑体=黑体;仿宋=仿宋;楷体=楷体;隶书=隶书;幼圆=幼圆;"+"Andale Mono=andale mono,times;"+
                "Arial=arial,helvetica,sans-serif;"+
                "Arial Black=arial black,avant garde;"+
                "Book Antiqua=book antiqua,palatino;"+
                "Comic Sans MS=comic sans ms,sans-serif;"+
                "Courier New=courier new,courier;"+
                "Georgia=georgia,palatino;"+
                "Helvetica=helvetica;"+
                "Impact=impact,chicago;"+
                "Symbol=symbol;"+
                "Tahoma=tahoma,arial,helvetica,sans-serif;"+
                "Terminal=terminal,monaco;",
                image_advtab: true,
                setup: function(editor) {
                    editor.on('init', function(e) {
                    	tinymce.activeEditor.setContent($("#"+$textArea.attr('id')).text());
                    });
                }
            });
        },

        onSave: function(event) {
            event.preventDefault();
            var targetModel = this.eventModel(event);
            //targetModel.set({ date : this.dateEntry(event).val(), content : this.$codeMirror.getValue() });
            var new_content = tinyMCE.get(this.textarea_id).getContent();
            if($("#is_send_mail_"+this.textarea_id).attr("checked")){
                send_mail= 'true'
            }else{
                send_mail = 'false'
            };
            targetModel.set({ date : this.dateEntry(event).val(), content : new_content,is_send_mail:send_mail });
            $("#"+this.textarea_id).text(new_content);
            // push change to display, hide the editor, submit the change
            var saving = new NotificationView.Mini({
                title: gettext('Saving&hellip;')
            });
            saving.show();
            var ele = this.modelDom(event);
            targetModel.save({}, {
                success: function() {
                    saving.hide();
                },
                error: function() {
                    ele.remove();
                }
            });
            this.closeEditor(false);

            analytics.track('Saved Course Update', {
                'course': course_location_analytics,
                'date': this.dateEntry(event).val()
            });
        },

        onCancel: function(event) {
            event.preventDefault();
            // change editor contents back to model values and hide the editor
            $(this.editor(event)).hide();
            // If the model was never created (user created a new update, then pressed Cancel),
            // we wish to remove it from the DOM.
            var targetModel = this.eventModel(event);
            this.closeEditor(!targetModel.id);
            tinymce.remove();
        },

        onEdit: function(event) {
            event.preventDefault();
            var self = this;
            this.$currentPost = $(event.target).closest('li');
            this.$currentPost.addClass('editing');
            $(this.editor(event)).show();
            var $textArea = this.$currentPost.find(".new-update-content").first();
            var targetModel = this.eventModel(event);
          //  this.$codeMirror = CourseInfoHelper.editWithCodeMirror(
           //     targetModel, 'content', self.options['base_asset_url'], $textArea.get(0));

            // Variable stored for unit test.
            this.$modalCover = ModalUtils.showModalCover(false,
                function() {
                    self.closeEditor(false)
                }
            );
            this.textarea_id = $textArea.attr('id');
            tinymce.init({
                selector: "textarea#"+$textArea.attr('id'),
                theme: "modern",
                language_url: tinymce_language_url,
                plugins: [
                    "advlist autolink lists link image charmap print preview hr anchor pagebreak",
                    "searchreplace  visualblocks visualchars code",
                    "insertdatetime media nonbreaking save table contextmenu directionality",
                    "emoticons paste textcolor colorpicker textpattern"
                ],
                toolbar1: "insertfile undo redo | styleselect fontselect fontsizeselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media | forecolor backcolor",
                font_formats:"宋体=宋体;黑体=黑体;仿宋=仿宋;楷体=楷体;隶书=隶书;幼圆=幼圆;"+"Andale Mono=andale mono,times;"+
                "Arial=arial,helvetica,sans-serif;"+
                "Arial Black=arial black,avant garde;"+
                "Book Antiqua=book antiqua,palatino;"+
                "Comic Sans MS=comic sans ms,sans-serif;"+
                "Courier New=courier new,courier;"+
                "Georgia=georgia,palatino;"+
                "Helvetica=helvetica;"+
                "Impact=impact,chicago;"+
                "Symbol=symbol;"+
                "Tahoma=tahoma,arial,helvetica,sans-serif;"+
                "Terminal=terminal,monaco;",
                image_advtab: true,
                
                setup: function(editor) {
                    editor.on('init', function(e) {
                    	tinymce.activeEditor.setContent($("#"+$textArea.attr('id')).text());
                    });
                }
            });
        },

        onDelete: function(event) {
            event.preventDefault();

            var self = this;
            var targetModel = this.eventModel(event);
            var confirm = new PromptView.Warning({
                title: gettext('Are you sure you want to delete this update?'),
                message: gettext('This action cannot be undone.'),
                actions: {
                    primary: {
                        text: gettext('OK'),
                        click: function () {
                            analytics.track('Deleted Course Update', {
                                'course': course_location_analytics,
                                'date': self.dateEntry(event).val()
                            });
                            self.modelDom(event).remove();
                            var deleting = new NotificationView.Mini({
                                title: gettext('Deleting&hellip;')
                            });
                            deleting.show();
                            targetModel.destroy({
                                success: function (model, response) {
                                    self.collection.fetch({
                                        success: function() {
                                            self.render();
                                            deleting.hide();
                                        },
                                        reset: true
                                    });
                                }
                            });
                            confirm.hide();
                        }
                    },
                    secondary: {
                        text: gettext('Cancel'),
                        click: function() {
                            confirm.hide();
                        }
                    }
                }
            });
            confirm.show();
        },

        closeEditor: function(removePost) {
            var targetModel = this.collection.get(this.$currentPost.attr('name'));

            if(removePost) {
                this.$currentPost.remove();
            }
            else {
                // close the modal and insert the appropriate data
                this.$currentPost.removeClass('editing');
                this.$currentPost.find('.date-display').html(targetModel.get('date'));
                this.$currentPost.find('.date').val(targetModel.get('date'));

                var content = CourseInfoHelper.changeContentToPreview(
                    targetModel, 'content', this.options['base_asset_url']);
                try {
                    // just in case the content causes an error (embedded js errors)
                    this.$currentPost.find('.update-contents').html(content);
                    this.$currentPost.find('.new-update-content').val(content);
                } catch (e) {
                    // ignore but handle rest of page
                }
                this.$currentPost.find('form').hide();
                this.$currentPost.find('.CodeMirror').remove();
            }

            ModalUtils.hideModalCover(this.$modalCover);
            this.$codeMirror = null;
        },

        // Dereferencing from events to screen elements
        eventModel: function(event) {
            // not sure if it should be currentTarget or delegateTarget
            return this.collection.get($(event.currentTarget).attr("name"));
        },

        modelDom: function(event) {
            return $(event.currentTarget).closest("li");
        },

        editor: function(event) {
            var li = $(event.currentTarget).closest("li");
            if (li) return $(li).find("form").first();
        },

        dateEntry: function(event) {
            var li = $(event.currentTarget).closest("li");
            if (li) return $(li).find(".date").first();
        },

        contentEntry: function(event) {
            return $(event.currentTarget).closest("li").find(".new-update-content").first();
        },

        dateDisplay: function(event) {
            return $(event.currentTarget).closest("li").find("#date-display").first();
        },

        contentDisplay: function(event) {
            return $(event.currentTarget).closest("li").find(".update-contents").first();
        }

    });

    return CourseInfoUpdateView;
}); // end define()
