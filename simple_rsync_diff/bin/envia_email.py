#!usr/bin/python

import smtplib
import sys
import os.path

from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEBase import MIMEBase
from email import encoders

# Acrescente aqui os dados respectivos para o envio dos logs
fromaddr = ""
toaddr = ""

# A comunicacao com o servidor de email sera feita via porta 587 usando TLS
mailserver = ""
password = ""
 
msg = MIMEMultipart()
 
msg['From'] = fromaddr
msg['To'] = toaddr
msg['Subject'] = "BRDSOFT - Rotina de backup - %s" % sys.argv[2]
 
body = "Em anexo segue log do backup executado"
 
msg.attach(MIMEText(body, 'plain'))
 
filename = os.path.basename(sys.argv[1])
attachment = open(sys.argv[1], "rb")
 
part = MIMEBase('application', 'octet-stream')
part.set_payload((attachment).read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', "attachment; filename= %s" % filename)
 
msg.attach(part)
 
server = smtplib.SMTP(mailserver, 587)
server.starttls()
server.login(fromaddr, password)
text = msg.as_string()
server.sendmail(fromaddr, toaddr, text)
server.quit()
