if exists("b:current_syntax")
  finish
endif

syn match pdbComment "TITLE.*"
syn match pdbComment "REMARK.*"
syn match pdbCryst "CRYST1.*"

syn keyword pdbKeyAtom ATOM nextgroup=pdbAtomId
syn keyword pdbTer TER
syn match pdbAtomId "\s*\d\{1,5}" nextgroup=pdbAtomName contained
syn match pdbAtomName "\s*.\{1,4}" nextgroup=pdbResName contained
syn match pdbResName "\s*.\{1,3}" nextgroup=pdbChainId contained
syn match pdbChainId "\s*[a-zA-Z]\{0,1}" nextgroup=pdbResId  contained
syn match pdbResId "\s*\d\{1,4}" nextgroup=pdbCoords contained
syn match pdbCoords "\s*\([0-9-]\|\s\|\.\)\{1,24}" nextgroup=pdbBFac contained 
syn match pdbBFac "\s*\([0-9-]\|\.\)\{1,6}" nextgroup=pdbTemp contained
syn match pdbTemp "\s*\([0-9-]\|\.\)\{1,6}" nextgroup=pdbElement contained
syn match pdbElement "\s*.\{1,4}" contained


"hi def link pdbComment Comment
hi def link pdbCryst Constant 
hi def link pdbTer Keyword

" hi def link pdbKeyAtom Comment
hi def link pdbAtomId Constant
hi def link pdbAtomName Special
hi def link pdbResName Special
hi def link pdbChainId Keyword
hi def link pdbResId Constant
hi def link pdbCoords Type
hi def link pdbBFac Type
hi def link pdbTemp Type
hi def link pdbElement Constant
