set folder      = imaps://telnoratti@gmail.com@imap.gmail.com/
mailboxes       = +INBOX =[Gmail]/Drafts =[Gmail]/'Sent Mail' =[Gmail]/Spam =[Gmail]/Trash
set spoolfile   = +INBOX
folder-hook     imaps://telnoratti@gmail.com@imap.gmail.com/ "\
    set folder  = imaps://telnoratti@gmail.com@imap.gmail.com/ \
    spoolfile   = +INBOX \
    postponed   = +[Gmail]/Drafts \
    record      = +[Gmail]/'Sent Mail' \
    mbox        = +[Gmail]/'All Mail' \
    from        = 'Calvin Winkowski <telnoratti@gmail.com>' \
    realname    = 'Calvin Winkowski' \
    smtp_url    = smtps://telnoratti@gmail.com@smtp.gmail.com \
    smtp_pass   = $my_pass_vt"

