# -*- coding: utf-8 -*
from pkg_resources import resource_string

from xmodule.x_module import XModule
from xmodule.raw_module import RawDescriptor
from xmodule.editing_module import MetadataOnlyEditingDescriptor
from xblock.fields import String, Scope
from uuid import uuid4


class DiscussionFields(object):
    discussion_id = String(scope=Scope.settings, default="$$GUID$$")
    display_name = String(
        display_name="Display Name",
        help="Display name for this module",
        default="Discussion",
        scope=Scope.settings
    )
    data = String(
        help="XML data for the problem",
        scope=Scope.content,
        default="<discussion></discussion>"
    )
    discussion_category = String(
        display_name="Category",
        default="Week 1",
        help="A category name for the discussion. This name appears in the left pane of the discussion forum for the course.",
        scope=Scope.settings
    )
    discussion_target = String(
        display_name="Subcategory",
        default="Topic-Level Student-Visible Label",
        help="A subcategory name for the discussion. This name appears in the left pane of the discussion forum for the course.",
        scope=Scope.settings
    )
    sort_key = String(scope=Scope.settings)


class DiscussionModule(DiscussionFields, XModule):
    js = {
        'coffee': [
            resource_string(__name__, 'js/src/discussion/display.coffee')
        ],
        'js': [
            resource_string(__name__, 'js/src/time.js')
        ]
    }
    js_module_name = "InlineDiscussion"

    def get_html(self):
        context = {
            'discussion_id': self.discussion_id,
        }
        return self.system.render_template('discussion/_discussion_module.html', context)


class DiscussionDescriptor(DiscussionFields, MetadataOnlyEditingDescriptor, RawDescriptor):

    def __init__(self, *args, **kwargs):
        super(DiscussionDescriptor, self).__init__(*args, **kwargs)
        # is this too late? i.e., will it get persisted and stay static w/ the first value
        # any code references. I believe so.
        if self.discussion_id == '$$GUID$$':
            self.discussion_id = uuid4().hex

    module_class = DiscussionModule
    # The discussion XML format uses `id` and `for` attributes,
    # but these would overload other module attributes, so we prefix them
    # for actual use in the code
    metadata_translations = dict(RawDescriptor.metadata_translations)
    metadata_translations['id'] = 'discussion_id'
    metadata_translations['for'] = 'discussion_target'

    @property
    def non_editable_metadata_fields(self):
        non_editable_fields = super(DiscussionDescriptor, self).non_editable_metadata_fields
        # We may choose to enable sort_keys in the future, but while Kevin is investigating....
        non_editable_fields.extend([DiscussionDescriptor.discussion_id, DiscussionDescriptor.sort_key])
        return non_editable_fields