#!/bin/bash
#
# [�X�N���v�g��]
# send-mail.sh
#
# [����]
#  �Ȃ�
#
# [�߂�l]
#  0:����I��
#  1:�ُ�I��
#
# [�������e]
#  ���s���ʃ��[�����M
#  �I������
#
#--------------------------------------------
#============================================
# ��Ɨp�ϐ�
#============================================
# �^�C���X�^���v
NOW=`date "+%Y-%m-%d %H:%M:%S"`
# ���t
TODAY=`date "+%Y%m%d"`
# ��ƃ��[�g�f�B���N�g��
WORK_DIR="$(dirname $0)/"
# ���O�i�[�f�B���N�g��
LOG_DIR="${WORK_DIR}log"
# �X�N���v�g���O�t�@�C��
SCRIPT_LOG="${LOG_DIR}/${TODAY}.script.log"

## ���[�����M�p�ϐ�
# ���[�����M�X�N���v�g
PY_SEND_MAIL="${WORK_DIR}/send_mail.py"
# ���M���A�h���X
FROM="noreply@xxx"
# ���M��A�h���X
TO="server1@mail.test"
# ���M��CC�A�h���X
CC="user1@mail.test"
# ����I�������[���^�C�g��
SUBJECT_SUCCESS="�yxxx�z�������������܂����B"
# �ُ�I�������[���^�C�g��
SUBJECT_FAILED="�yxxx�z���������s���܂����B"
# ��O���[���^�C�g��
SUBJECT_EXCEPTION="�yxxx�zXX�����݂��܂���B"
# �����������[���{��
MAIL_TEMPLATE="${WORK_DIR}/mail-text.txt"
# �G���[�ʒm���[���{��
ERR_MAIL_TEMPLATE="${WORK_DIR}/error-mail-text.txt"
# �G���[�A�h���X�폜����(str1)
RESULT1="${WORK_DIR}/result/${TODAY}.result1.txt"
# �G���[�A�h���X�폜����(str2)
RESULT2="${WORK_DIR}/result/${TODAY}.result2.txt


######################################################################
# �֐���`
######################################################################
#---------------------------------------------------------------------
# �X�N���v�g���O�o��
#---------------------------------------------------------------------
function fnc_output_scriptlog() {
  (echo "$NOW: $1" >>$SCRIPT_LOG) 2>/dev/null
  return $?
}

#---------------------------------------------------------------------
# ���[�����M�֐�
#---------------------------------------------------------------------
# ��������
function fnc_send_mail() {
  mail_text=$(sed -e 's#%HOSTNAME%#'$(hostname)'#' -e 's#%str1%#'"$(grep flag ${RESULT1} | awk '{print $2}')"'#' -e 's#%str2%#'"$(grep flag ${RESULT2} | awk '{print $2}')"'#' ${MAIL_TEMPLATE})
  echo "${mail_text}" | ${PY_SEND_MAIL} "${FROM}" "${TO}" "${CC}" "${SUBJECT_SUCCESS}"
  return $?
}

# �������s
function fnc_send_error_mail() {
  mail_text=$(sed -e 's#%HOSTNAME%#'$(hostname)'#' -e 's#%str%#'"$1"'#' ${ERR_MAIL_TEMPLATE})
  echo "${mail_text}" | ${PY_SEND_MAIL} "${FROM}" "${TO}" "${SUBJECT_FAILED}"
  return $?
}

# ��O
function fnc_send_exception_mail() {
  mail_text=$(sed -e 's#%HOSTNAME%#'$(hostname)'#' -e 's#%str%#'"$1"'#' ${ERR_MAIL_TEMPLATE})
  echo "${mail_text}" | ${PY_SEND_MAIL} "${FROM}" "${TO}" "${SUBJECT_EXCEPTION}"
  return $?
}

#============================================
# ���C������
#============================================
#--------------------------------------------
# ���s���ʃ��[�����M
#--------------------------------------------
fnc_output_scriptlog "�J�n:���s���ʃ��[�����M"

fnc_send_mail

if [ "$?" != "0" ];then
    for i in fnc_output_scriptlog fnc_send_error_mail; do ${i} "���s���ʃ��[�����M�Ɏ��s���܂����B"; done
    exit 1
fi

fnc_output_scriptlog "�I��:���s���ʃ��[�����M"

#============================================
# �I������
#============================================

exit 0

