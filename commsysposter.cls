%%
%% This is file `commsysposter.cls'
%%
%% Created by Adrian Edin 2024-10-22
%%
%%

\ProvidesClass{commsysposter}[2024/10/22 v1.0 commsysposter class]

\LoadClass{article}

% \newif\ifdraft
\newif\ifcsp@centertitle
\newif\ifcsp@frames
\newlength{\postercolumnseparation}
\setlength{\postercolumnseparation}{0mm}

%% Size used to scale the inner content with respect to the outer;
\newlength{\csp@headerwidth}

\newlength{\posterheaderheight}

% This fits nicely with the standard header.
\setlength{\posterheaderheight}{3cm}

\DeclareOption{1col}{
	\def\csp@columnsnum{1}
}

\DeclareOption{2col}{
	\def\csp@columnsnum{2}
}

\DeclareOption{3col}{
	\def\csp@columnsnum{3}
}

\DeclareOption{4col}{
	\def\csp@columnsnum{4}
}

\DeclareOption{a0b}{
	\PassOptionsToPackage{papersize={91.51cm,120cm}}{geometry}
}
\DeclareOption{a0}{
	\PassOptionsToPackage{a0paper}{geometry}
}
\DeclareOption{a1}{
	\PassOptionsToPackage{a1paper}{geometry}
	\setlength{\postercolumnseparation}{5mm}
}
\DeclareOption{a2}{
	\PassOptionsToPackage{a2paper}{geometry}
	\setlength{\postercolumnseparation}{4mm}
}
\DeclareOption{a3}{
	\PassOptionsToPackage{a3paper}{geometry}
	\setlength{\postercolumnseparation}{3mm}
}
\DeclareOption{a4}{
	\PassOptionsToPackage{a4paper}{geometry}
	\setlength{\postercolumnseparation}{2.5mm}
}

\DeclareOption{landscape}{
	\PassOptionsToPackage{landscape}{geometry}
}
\DeclareOption{portrait}{
	\PassOptionsToPackage{portrait}{geometry}
}
\DeclareOption{centertitle}{
	\csp@centertitletrue
}
\DeclareOption{showframes}{
	\csp@framestrue
}

\DeclareOption*{\PackageWarning{commsysposter}{Unknown Option \CurrentOption}}
\ExecuteOptions{portrait,a3,3col}
\ProcessOptions\relax

\newlength{\csp@bottommargin}\setlength{\csp@bottommargin}{10mm}% 10mm
\newlength{\csp@topmargin}\setlength{\csp@topmargin}{8mm}%{5mm}
\newlength{\postertitletocontentmargin}\setlength{\postertitletocontentmargin}{4mm}

\PassOptionsToPackage{hmargin=1cm}{geometry}
\PassOptionsToPackage{top=\csp@topmargin, bottom=\csp@bottommargin}{geometry}

\newcommand\boxtitle[1]{{\large\sf\textbf{#1}}}
\ifcsp@frames
	\RequirePackage{showframe}
\fi

\RequirePackage{geometry}
\RequirePackage{parskip}
\RequirePackage{xcolor,graphicx}
\RequirePackage[framemethod=TikZ]{mdframed}
\usetikzlibrary{shadows}



\definecolor{LiUblue}{HTML}{00B3E7}
\definecolor{LiUblack}{HTML}{231F20}
\definecolor{LiUturquoise}{HTML}{0CC7D3}
\definecolor{LiUgreen}{HTML}{00CFB6}
\definecolor{LiUorange}{HTML}{FF6442}
\definecolor{LiUpurple}{HTML}{8781D3}
\definecolor{LiUyellow}{HTML}{FCF05F}
\definecolor{LiUgrey}{HTML}{687F91}

\colorlet{postercyan}{LiUturquoise!20}
\colorlet{posteryellow}{LiUyellow!20}
\colorlet{posterblue}{LiUblue!20}
\colorlet{posterpurple}{LiUpurple!20}
\colorlet{posterred}{LiUorange!50}
\colorlet{postergrey}{LiUgrey!20}
\colorlet{postergreen}{LiUgreen!30}
\colorlet{posterorange}{LiUorange!20}

\colorlet{titlecolor}{LiUblack}
\colorlet{backgroundcolor}{LiUblue!5}
%\colorlet{backgroundcolor}{white}
\pagecolor{backgroundcolor}
\colorlet{posterboxlinecolor}{black}

% Creating commands for setting title author and affiliation
\newcommand{\postertitle}{}
\newcommand{\posterauthor}{}
\newcommand{\posteraffiliation}{Div.\ of Communication Systems, Dept.\ of Electrical Engineering (ISY),
	Link\"{o}ping University (LiU), \\581 83 Link\"oping, Sweden}

\renewcommand{\title}[1]{\renewcommand{\postertitle}{#1}}
\renewcommand{\author}[1]{\renewcommand{\posterauthor}{#1}}
\renewcommand{\refname}{\vskip -3em}
\newcommand{\affiliation}[1]{\renewcommand{\posteraffiliation}{#1}}


\newcommand{\csp@leftlogo}{templateresources/LiUlogo.eps}
\newcommand{\csp@rightlogo}{templateresources/CommSyslogo.eps}

\newcommand{\leftlogo}[1]{\renewcommand{\csp@leftlogo}{#1}}
\newcommand{\rightlogo}[1]{\renewcommand{\csp@rightlogo}{#1}}

\newcommand{\leftlogoscalingfactor}{1}
\newcommand{\rightlogoscalingfactor}{1}

\newsavebox{\csp@titlecontent}
\newsavebox{\csp@postercontent}
\newsavebox{\csp@postercolumncontent}
% \newsavebox{\posterboxcontent}

\newlength{\csp@@columnwidth}
\newlength{\csp@@totalareaheight}
\newlength{\csp@@totalareawidth}
\newlength{\csp@@currentareaheight}
\newlength{\csp@@currentareawidth}
\newlength{\csp@@currentcolumnwidth}


% First command is number of columns
% Second is the fractional width of parent
% Third is the fractional height of parent
\NewDocumentEnvironment{posterarea}{O{3} o o}{%
	\def\csp@columnsnum{#1}%
	\IfValueTF{#2}{%
		\setlength{\csp@@currentareawidth}{\dimexpr #2\csp@@currentareawidth}%
	}{%
		% \setlength{\csp@@currentareawidth}{\dimexpr \csp@@totalareawidth}%
	}%
	\IfValueTF{#3}{%
		\setlength{\csp@@currentareaheight}{\dimexpr #3\csp@@currentareaheight}%
	}{%
		% \setlength{\csp@@currentareaheight}{\dimexpr \csp@@totalareaheight}%
	}%
	% Set the standard width of the columns here based on the number of columns given
	\setlength{\csp@@columnwidth}{\dimexpr (\csp@@currentareawidth)/\number\csp@columnsnum\relax}%
	%
	\begin{lrbox}{\csp@postercontent}
		\begin{minipage}[t][\csp@@currentareaheight]{\csp@@currentareawidth}%
			\ignorespaces%
	}{
		\end{minipage}%
	\end{lrbox}%
		% Don't externalize these parts ragardless
		\ifcsname tikz@library@external@loaded\endcsname\tikzexternaldisable\fi%
		\ifcsp@frames%
			\setlength{\fboxrule}{1pt}%
			\setlength{\fboxsep}{-\fboxrule}% Just for this example
			\fbox{%
		\fi%
		\ignorespaces\usebox{\csp@postercontent}%
		\ifcsp@frames}\fi%
		\ifcsname tikz@library@external@loaded\endcsname\tikzexternalenable\fi%
		\vskip -\baselineskip \relax\vfill
		\par}
		%\ignorespacesafterend}



\NewDocumentEnvironment{postercolumn}{o}{%
	\IfValueTF{#1}{%
		\setlength{\csp@@columnwidth}{\dimexpr (#1\csp@@currentareawidth)\relax}%
	}{%
		% This is already set
	}%
	% \setlength{\csp@@columnwidth}{\dimexpr (\textwidth)/\number\csp@columnsnum\relax}%
	\setlength{\csp@@currentareawidth}{\csp@@columnwidth}%
	\begin{lrbox}{\csp@postercolumncontent}%
		\begin{minipage}[t][\csp@@currentareaheight]{\dimexpr\csp@@columnwidth}%
			\ignorespaces
			}{%
			\end{minipage}%
		\end{lrbox}%
	\ifcsp@frames%
		\setlength{\fboxrule}{1pt}%
		\setlength{\fboxsep}{-\fboxrule}%
		\fbox{%
	\fi%
	\usebox{\csp@postercolumncontent}%
	\ifcsp@frames}\fi%
	\ignorespacesafterend%
}

\mdfdefinestyle{posterstyle}{
}

\mdfdefinestyle{csp@framestyle}{
	linecolor=white!20!black,
	linewidth=0.6pt,
	backgroundcolor=gray!40,
	shadow=true,
	shadowsize = 6pt,
	%backgroundcolor=red!10,
	roundcorner=4pt,
	skipbelow = 0mm,
	innerbottommargin=3mm,
	innerleftmargin=3mm,
	innerrightmargin=3mm,
	leftmargin = \dimexpr (\postercolumnseparation)/2,
	rightmargin = \dimexpr (\postercolumnseparation)/2
}

\NewDocumentEnvironment{posterbox}{O{white} m O{}}{%
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternaldisable\fi%
	% Only add a header it is non-empty
	\ifstrempty{#2}{%
	\begin{mdframed}[style=csp@framestyle, style=posterstyle,
		innertopmargin=3mm,
		backgroundcolor=#1,
		#3]%
	}{
	\begin{mdframed}[style=csp@framestyle, style=posterstyle,
		backgroundcolor=#1,
		innertopmargin=0mm,
		frametitleaboveskip = 2mm,
		frametitle=\boxtitle{#2},
		#3]%
	}
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternalenable\fi%
	\ignorespaces
	}{%
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternaldisable\fi%
	\end{mdframed}%[\posterboxseparator]
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternalenable\fi%
	\vfill%
	\ignorespacesafterend%
}

\NewDocumentCommand{\posterspacer}{m}{%
	\vspace*{\dimexpr #1\csp@@currentareaheight}%
	\ignorespacesafterend%
}

% This is just a short macro to create two mini columns within a posterbox.
\NewDocumentCommand{\minicolumns}{ O{0.5} o m m }{
	\IfValueTF{#2}
	{%
	\begin{minipage}{\dimexpr #2}
		\begin{minipage}{\dimexpr (#1#2)-0.01#2\relax}%
			#3
		\end{minipage}\hfill%
		\begin{minipage}{\dimexpr (#2-#1#2)-0.01#2\relax}%
			#4
		\end{minipage}%
	\end{minipage}%
	}
	{%
	\begin{minipage}{\textwidth}%
		\begin{minipage}{\dimexpr (#1\textwidth)-0.01\textwidth}%
			#3
		\end{minipage}\hfill%
		\begin{minipage}{\dimexpr (\textwidth-#1\textwidth)-0.01\textwidth}%
			#4
		\end{minipage}%
	\end{minipage}%
	}
}


\AtBeginDocument{%
	\ifcsp@centertitle%
		\mdfsetup{frametitlealignment=\center}%
	\fi%
	\setlength{\csp@headerwidth}{\dimexpr \textwidth}%
	\ifGm@landscape % Check if geometry is loaded with landscape flag
		\addtolength{\csp@headerwidth}{-30.0mm}%
	\else%
		\addtolength{\csp@headerwidth}{0mm}%
	\fi%
	\pagestyle{empty}%
	\newlength{\csp@headerlogoheight}\setlength{\csp@headerlogoheight}{0.9\posterheaderheight}%
	\newlength{\csp@headerlogowidth}\setlength{\csp@headerlogowidth}{0.15\csp@headerwidth}%
	\begin{lrbox}{\csp@titlecontent}%
		\begin{minipage}[]{\csp@headerlogowidth}%
			\centerline{\includegraphics[height=\leftlogoscalingfactor\csp@headerlogoheight,width=\leftlogoscalingfactor\csp@headerlogowidth,keepaspectratio]{\csp@leftlogo}}
		\end{minipage}%
		\hfill
		\begin{minipage}{0.7\csp@headerwidth}\sf
			\centering \Huge \textbf{\textcolor{titlecolor}\postertitle} \\
			\vspace{0.3cm}
			\Large \textbf{\textcolor{titlecolor}\posterauthor}\\
			\normalsize \textcolor{titlecolor}\posteraffiliation\\
		\end{minipage}%
		\hfill
		\begin{minipage}{\csp@headerlogowidth}
			\centerline{\includegraphics[height=\rightlogoscalingfactor\csp@headerlogoheight,width=\rightlogoscalingfactor\csp@headerlogowidth,keepaspectratio]{\csp@rightlogo}}
		\end{minipage}%
	\end{lrbox}%
	\hfill%
	\ifcsp@frames%
		\setlength{\fboxrule}{1pt}%
		\setlength{\fboxsep}{-\fboxrule}%
		\fbox{\fi%
	\begin{minipage}[c][\posterheaderheight]{\csp@headerwidth}%
		\usebox{\csp@titlecontent}%
	\end{minipage}%
	\ifcsp@frames}\fi%
	\hfill\null%
	\vskip\postertitletocontentmargin%
	% Set the poster area dimension
	\setlength{\csp@@totalareaheight}{\dimexpr \textheight-\postertitletocontentmargin-\posterheaderheight-6pt\relax} % -2\baselineskip
	\setlength{\csp@@totalareawidth}{\textwidth}%
	% Initiate the current measures too.
	\setlength{\csp@@currentareaheight}{\csp@@totalareaheight}%
	\setlength{\csp@@currentareawidth}{\csp@@totalareawidth}%
	% Define columns size such that columns can be used directly
	\setlength{\csp@@columnwidth}{\dimexpr (\csp@@currentareawidth)/\number\csp@columnsnum\relax}%
	%
	%\vskip -\baselineskip\relax%
	%\the\baselineskip, \the\dimexpr2mm
	}


\newcommand{\wasplogobox}
{\begin{posterbox}[gray]{}
		\centering
		\vspace*{2mm}
		\includegraphics[width=0.9\textwidth,height=1cm,keepaspectratio]{templateresources/waspwhite.eps}\vspace*{2mm}
	\end{posterbox}
	}


\endinput
