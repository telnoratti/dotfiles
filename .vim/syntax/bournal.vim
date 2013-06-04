if exists("b:current_syntax")
  finish
endif

syn match   bournalHeader   "^# Subject: .*\n#.*20[0-9][0-9]$"
syn match bournalHeader "^# Subject: .*\n^# [Mon|Teu|Wed|Thu|Fri|Sat|Sun].*20[0-9][0-9]$"hs=s,he=e
hi bournalHeader ctermfg=Grey

let b:current_syntax = "bournal"

