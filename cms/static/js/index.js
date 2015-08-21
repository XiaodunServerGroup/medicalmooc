    require(["domReady", "jquery", "underscore", "js/utils/cancel_on_escape"],
    function (domReady, $, _, CancelOnEscape) {
        var saveNewCourse = function (e) {
            e.preventDefault();

            // One final check for empty values
            var errors = _.reduce(
                ['.new-course-name', '.new-course-org', '.new-course-number', '.new-course-run'],
                function (acc, ele) {
                    var $ele = $(ele);
                    var error = validateRequiredField($ele.val());
                    setNewCourseFieldInErr($ele.parent('li'), error);
                    return error ? true : acc;
                },
                false
            );

            if (errors) {
                return;
            }

            var $newCourseForm = $(this).closest('#create-course-form');
            var display_name = $newCourseForm.find('.new-course-name').val();
            var course_category = $newCourseForm.find('.new-course-category').val();
            var course_childcategory = $newCourseForm.find('.new-course-childcategory').val();
            var course_level = $newCourseForm.find('.new-course-level').val();
            var course_price = $newCourseForm.find('.new-course-price').val();
            var org = $newCourseForm.find('.new-course-org').val();
            var number = $newCourseForm.find('.new-course-number').val();
            var run = $newCourseForm.find('.new-course-run').val();

            analytics.track('Created a Course', {
                'org': org,
                'number': number,
                'display_name': display_name,
                'run': run
            });

            $.postJSON('/course', {
                    'org': org,
                    'course_category': course_category,
                    'course_childcategory': course_childcategory,
                    'course_level': course_level,
                    'course_price': course_price,
                    'number': number,
                    'display_name': display_name,
                    'run': run
                },
                function (data) {
                    if (data.url !== undefined) {
                        window.location = data.url;
                    } else if (data.ErrMsg !== undefined) {
                        $('.wrap-error').addClass('is-shown');
                        $('#course_creation_error').html('<p>' + data.ErrMsg + '</p>');
                        $('.new-course-save').addClass('is-disabled');
                    }
                }
            );
        };

        var cancelNewCourse = function (e) {
            e.preventDefault();
            $('.new-course-button').removeClass('is-disabled');
            $('.wrapper-create-course').removeClass('is-shown');
            // Clear out existing fields and errors
            _.each(
                ['.new-course-name', '.new-course-org', '.new-course-number', '.new-course-category', '.new-course-childcategory', 'new-course-level', 'new-course-price', '.new-course-run'],
                function (field) {
                    $(field).val('');
                }
            );
            $('#course_creation_error').html('');
            $('.wrap-error').removeClass('is-shown');
            $('.new-course-save').off('click');
        };

        var addNewCourse = function (e) {
            e.preventDefault();
            $('.new-course-button').addClass('is-disabled');
            $('.new-course-save').addClass('is-disabled');
            var $newCourse = $('.wrapper-create-course').addClass('is-shown');
            var $cancelButton = $newCourse.find('.new-course-cancel');
            var $courseName = $('.new-course-name');
            $courseName.focus().select();
            $('.new-course-save').on('click', saveNewCourse);
            $cancelButton.bind('click', cancelNewCourse);
            CancelOnEscape($cancelButton);

            // Check that a course (org, number, run) doesn't use any special characters
            var validateCourseItemEncoding = function (item) {
                var required = validateRequiredField(item);
                if (required) {
                    return required;
                }
                if (/\s/g.test(item)) {
                    return gettext('Please do not use any spaces in this field.');
                }
                return '';
            };

            // Ensure that org/course_num/run < 65 chars.
            var validateTotalCourseItemsLength = function () {
                var totalLength = _.reduce(
                    ['.new-course-org', '.new-course-number', '.new-course-run'],
                    function (sum, ele) {
                        return sum + $(ele).val().length;
                    }, 0
                );
                if (totalLength > 65) {
                    $('.wrap-error').addClass('is-shown');
                    $('#course_creation_error').html('<p>' + gettext('The combined length of the organization, course number, and course run fields cannot be more than 65 characters.') + '</p>');
                    $('.new-course-save').addClass('is-disabled');
                }
                else {
                    $('.wrap-error').removeClass('is-shown');
                }
            };

            // Handle validation asynchronously
            _.each(
                ['.new-course-org', '.new-course-number', '.new-course-run'],
                function (ele) {
                    var $ele = $(ele);
                    $ele.on('keyup', function (event) {
                        // Don't bother showing "required field" error when
                        // the user tabs into a new field; this is distracting
                        // and unnecessary
                        if (event.keyCode === 9) {
                            return;
                        }
                        var error = validateCourseItemEncoding($ele.val());
                        setNewCourseFieldInErr($ele.parent('li'), error);
                        validateTotalCourseItemsLength();
                    });
                }
            );
            var $name = $('.new-course-name');
            $name.on('keyup', function () {
                var error = validateRequiredField($name.val());
                setNewCourseFieldInErr($name.parent('li'), error);
                validateTotalCourseItemsLength();
            });
        };

        var validateRequiredField = function (msg) {
            return msg.length === 0 ? gettext('Required field.') : '';
        };

        var setNewCourseFieldInErr = function (el, msg) {
            if(msg) {
                el.addClass('error');
                el.children('span.tip-error').addClass('is-showing').removeClass('is-hiding').text(msg);
                $('.new-course-save').addClass('is-disabled');
            }
            else {
                el.removeClass('error');
                el.children('span.tip-error').addClass('is-hiding').removeClass('is-showing');
                // One "error" div is always present, but hidden or shown
                if($('.error').length === 1) {
                    $('.new-course-save').removeClass('is-disabled');
                }
            }
        };

        domReady(function () {
            $('.new-course-button').bind('click', addNewCourse);
            $('select.new-course-category').html("" +
                "<option value='LCHYX'>临床医学</option>" +
                "<option value='JCHYX'>基础医学</option>" +
                "<option value='ZHYZHY'>中医中药</option>" +
                "<option value='KQYX'>口腔医学</option>" +
                "<option value='YX'>药学</option>" +
                "<option value='HL'>护理</option>" +
                "<option value='GGWSHYFYX'>公共卫生与预防医学</option>" +
                "<option value='YXYJ'>医学检验</option>"
            )
        });
    });
