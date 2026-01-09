from zope.interface import implementer
from zope.component import adapts
from archetypes.schemaextender.interfaces import ISchemaExtender
from archetypes.schemaextender.field import ExtensionField
from Products.Archetypes import atapi
from bika.lims.interfaces import IAnalysisRequest
from bika.lims import senaiteMessageFactory as _


class ExtensionStringField(ExtensionField, atapi.StringField):
    """A trivial extension field"""


@implementer(ISchemaExtender)
class SampleExtender(object):
    adapts(IAnalysisRequest)

    fields = [
        ExtensionStringField(
            'tubeId',
            widget=atapi.StringWidget(
                label=_("Tube ID"),
                description=_("Unique identifier for the sample tube"),
            ),
        ),
    ]

    def __init__(self, context):
        self.context = context

    def getFields(self):
        return self.fields
