# coding: utf-8
from django.db import models
from django.utils.translation import ugettext_lazy as _
from factory.django import DjangoModelFactory

from .model_service import CommonInfo, Service, WorkflowType


class Workflow(CommonInfo):
    service = models.ForeignKey(Service, verbose_name=_(
        "Service"), on_delete=models.CASCADE, related_name="workflows")
    name = models.CharField(_("Workflow name"), max_length=256)
    workflow_type = models.ForeignKey(WorkflowType, verbose_name=_(
        "Workflow type"), on_delete=models.CASCADE, related_name="workflow")
    content = models.TextField(_("Workflow content"))
    job_template = models.TextField(_("Workflow job template"))

    class Meta:
        db_table = "workflow"
        verbose_name = "workflow"
        verbose_name_plural = "workflows"

    def __str__(self):
        return "Workflow: {}".format(self.name)


class WorkflowFactory(DjangoModelFactory):
    class Meta:
        model = Workflow
