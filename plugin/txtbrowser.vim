" txtbrowser.vim:	Utilities to browser plain text file.
" Release:		1.1.6
" Maintainer:		ypguo<guoyoooping@163.com>
" Last modified:	2010.02.19
" License:		This script is released under the Vim License.

" ****************** Do not modify after this line ************************

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

if exists("g:txtbrowser_version")
	finish "stop loading the script
endif
let g:txtbrowser_version = "1.1.4"

"===================================================================
" User defined web dictionary
if !exists('TxtBrowser_Dict_Url')
	let TxtBrowser_Dict_Url = 'http://www.google.cn/dictionary?aq=f&langpair=en|zh-CN&q=text&hl=zh-CN'
endif

" User defined Search Engine.
if !exists('Txtbrowser_Search_Engine')
	let Txtbrowser_Search_Engine = 'http://www.google.com/search?hl=zh-CN&source=hp&q=text&btnG=Google+%E6%90%9C%E7%B4%A2&lr=&aq=f&oq='
endif

"===================================================================
" Define the user commands to manage the taglist window
command! -nargs=0 -bar TxtBrowserSearch call s:TxtbrowserOpenUrl(substitute(g:Txtbrowser_Search_Engine, "text", "<cword>", 'g'))
command! -nargs=0 -bar TxtBrowserWord call s:TxtbrowserOpenUrl(substitute(g:TxtBrowser_Dict_Url, "text", "<cword>", "g"))
command! -nargs=0 -bar TxtBrowserUrl call s:TxtbrowserOpenUrl(s:TxtbrowserParseUrl(getline(".")))

:map <Leader>s <ESC>:TxtBrowserSearch<CR>
:map <Leader>f <ESC>:TxtBrowserWord<CR>
:map <Leader>g <ESC>:TxtBrowserUrl<CR>

"===================================================================
" Function to parse and get the url in the line gvien.
" @line: input line that need to open.
" return: Url that prased, return "" if not found.
function! s:TxtbrowserParseUrl(line)
	" line
	"let url = matchstr(getline("."), '[filehtp]*:\/\/[^>,;]*')
	let url = matchstr(a:line, "http:\/\/[^ ()]*")
	:if url==""
	let url = matchstr(a:line, "ftp:\/\/[^ ]*")
	:endif
	:if url==""
	let url = matchstr(a:line, "file:\/\/[^,;>]*")
	:endif
	:if url==""
	let url = matchstr(a:line, "mailto:[^ ]*")
	:endif
	:if url==""
	let url = matchstr(a:line, "www\.[^ ()]*")
	:endif
	:if url==""
	let url = matchstr(a:line, "[^,:\> ]*@[^ ,:]*")
	:if url!=""
	:let url = "mailto:" . url
	:endif
	:endif
	let url = escape (url, "\"#;%")

	return url
endfunction

" Function to open the url gvien.
" @url: url that need to open.
function! s:TxtbrowserOpenUrl (url)
	if a:url == ""
		echohl ErrorMsg | echo "No url found in the cursor."
		return -1
	endif

	if (has("mac"))
		exec "!open \"" . a:url . "\""
	elseif (has("win32") || has("win32unix"))
		exec ':silent !cmd /q /c start "\""dummy title"\"" ' . "\"" . a:url . "\""
	elseif (has("unix"))
		exec ':silent !firefox ' . "\"" . a:url . "\" & "
	endif
endfunction

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

