from django.core.mail.message import EmailMultiAlternatives
def send_mails(subject, body, from_email, recipient_list, fail_silently=False, html=None, *args, **kwargs):
    msg = EmailMultiAlternatives(subject, body, from_email, recipient_list)
    if html:
        msg.attach_alternative(html, "text/html")
    msg.send(fail_silently)
