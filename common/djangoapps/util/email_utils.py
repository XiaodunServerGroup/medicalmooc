from django.core.mail.message import EmailMultiAlternatives
import smtplib

from django.core.mail.utils import DNS_NAME
from django.core.mail.backends.smtp import EmailBackend

class SSLEmailBackend(EmailBackend):
    def open(self):
        if self.connection:
            return False
        try:
            self.connection = smtplib.SMTP_SSL(self.host, self.port,
                                           local_hostname=DNS_NAME.get_fqdn())
            if self.username and self.password:
                self.connection.login(self.username, self.password)
            return True
        except:
            if not self.fail_silently:
                raise


def send_mails(subject, body, from_email, recipient_list, fail_silently=False, html=None, *args, **kwargs):
    msg = EmailMultiAlternatives(subject, body, from_email, recipient_list)
    if html:
        msg.attach_alternative(html, "text/html")
    msg.send(fail_silently)