#!/usr/bin/python
# -*- encoding=utf8 -*-
#
######################################################################
#
# [�T�v]
#  �X�N���v�g�̌��ʂ����[�����M����B���[�����M�ɕK�v�ȏ��́A
#  �Ăяo�����̊֐�(fnc_send_mail�܂���fnc_send_error_mail)���A
#  �����Ƃ��Ď󂯎��B
#
# [����]
#  CC����
#   ����1: ���M���A�h���X 
#   ����2: ���M��A�h���X
#   ����3: ���M��CC�A�h���X
#   ����4: ���[���^�C�g��
# 
#  CC�Ȃ�
#   ����1: ���M���A�h���X
#   ����2: ���M��A�h���X
#   ����3: ���[���^�C�g��
#
# �����L
#  �X�N���v�g�̏������������Ă��鎞��CC����
#  �X�N���v�g�̏��������s���Ă��鎞��CC�Ȃ�
#
# [�֘A�t�@�C��]
#  common_difinition.sh
#
######################################################################
# �o�[�W���� �쐬�^�X�V�� �X�V��      �ύX���e
#---------------------------------------------------------------------
# 001-01     XX         YYYY/MM/DD    �V�K�쐬
#
######################################################################
######################################################################
# ���O����
######################################################################
# ���W���[���C���|�[�g
import sys, smtplib
from email.MIMEText import MIMEText
from email.Header import Header
from email.Utils import formatdate
from datetime import datetime

# ��ƕϐ���`
argvs = sys.argv
argc = len(argvs)

today = datetime.now().strftime("%Y%m%d")
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

######################################################################
# ���C������
######################################################################
# �����R�[�h�ݒ�
charset = 'cp932'

# �A�h���X�A�����̐ݒ�(CC����)
if (argc == 5):
    from_address = argvs[1]
    to_address   = argvs[2]
    cc_address   = argvs[3]
    subject = unicode(argvs[4], 'utf-8')
# �A�h���X�A�����̐ݒ�(CC�Ȃ�)
elif (argc == 4):
    from_address = argvs[1]
    to_address   = argvs[2]
    subject = unicode(argvs[3], 'utf-8')
# �������������Ȃ��ꍇ
else:
    print 'Usage: # %s from to subject' % argvs[0]
    quit()

# �W�����͂��烁�[���{�����擾
text = ''
for line in sys.stdin:
    text = text + line
text = unicode(text, 'utf-8')

# ���M���[���̍쐬
msg = MIMEText(text.encode(charset), 'plain', charset)
msg['Subject'] = Header(subject, charset)
msg['From'] = from_address
msg['To'] = to_address
if (argc == 5):
    msg['Cc'] = cc_address
msg['Date'] = formatdate(localtime=True)

# ���[���̑��M
smtp = smtplib.SMTP('localhost')
if (argc == 5):
    smtp.sendmail(from_address, [to_address, cc_address], msg.as_string())
else:
    smtp.sendmail(from_address, to_address, msg.as_string())
smtp.close()

######################################################################
# ���㏈��
######################################################################
#���O�o��
f = open("/root/xxx/log/" + today + ".script.log",'a')
if (argc == 5):
    f.write(now + ": ���s���ʃ��[�������M����܂����B\n")
else:
    f.write(now + ": �G���[�ʒm���[�������M����܂���\n")
f.close()

sys.exit(0)

