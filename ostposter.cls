%%
%% This is file `ostposter.cls'
%%
%% Created by Adrian Edin 2024-10-22
%%
%%

\ProvidesClass{ostposter}[2024/10/22 v1.0 ostposter class]

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

\DeclareOption*{\PackageWarning{ostposter}{Unknown Option \CurrentOption}}
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
\RequirePackage[most]{tcolorbox}




\definecolor{postercyan}{HTML}{adf8d7}
\definecolor{posteryellow}{HTML}{fff5ba}
\definecolor{posterblue}{HTML}{6eb6ff}
\definecolor{posterpurple}{HTML}{b6b9ff}
\definecolor{posterred}{HTML}{ffbebc}
\definecolor{postergrey}{HTML}{e2e2e2}
\definecolor{postergreen}{HTML}{bdfcc3}
\definecolor{posterorange}{HTML}{ffcbc0}

% Tone the box colours down towards white. \csp@boxtint is the percentage of
% the original colour kept (lower = paler / closer to white).
\newcommand{\csp@boxtint}{30}
\colorlet{postercyan}{postercyan!\csp@boxtint!white}
\colorlet{posteryellow}{posteryellow!\csp@boxtint!white}
\colorlet{posterblue}{posterblue!\csp@boxtint!white}
\colorlet{posterpurple}{posterpurple!\csp@boxtint!white}
\colorlet{posterred}{posterred!\csp@boxtint!white}
\colorlet{postergrey}{postergrey!\csp@boxtint!white}
\colorlet{postergreen}{postergreen!\csp@boxtint!white}
\colorlet{posterorange}{posterorange!\csp@boxtint!white}

\colorlet{titlecolor}{black}
\colorlet{backgroundcolor}{posterblue!25}
%\colorlet{backgroundcolor}{white}
\pagecolor{backgroundcolor}
\colorlet{posterboxlinecolor}{black}

% Creating commands for setting title author and affiliation
\newcommand{\postertitle}{}
\newcommand{\posterauthor}{}
\newcommand{\posteraffiliation}{Div.\ of ..., Dept.\ of ...,
	University ..., The world.}

\renewcommand{\title}[1]{\renewcommand{\postertitle}{#1}}
\renewcommand{\author}[1]{\renewcommand{\posterauthor}{#1}}
\renewcommand{\refname}{\vskip -3em}
\newcommand{\affiliation}[1]{\renewcommand{\posteraffiliation}{#1}}


\newcommand{\csp@leftlogo}{example-image}
\newcommand{\csp@rightlogo}{example-image}

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

% Columns are laid out as side-by-side boxes inside a single horizontal
% "galley" paragraph. A stray \par (from a blank line between columns) would
% end that paragraph and wrap the next column onto a new line. To make the
% layout independent of how many blank lines appear between environments, we
% neutralize \par in the top-level galley: blank lines then become harmless.
% Box content is unaffected because minipage/\@parboxrestore restores a real
% \par locally, and we re-arm a real \par at \AtEndDocument so the final page
% can be shipped out (otherwise \newpage trips on \prevdepth while in hmode).
\newcommand\csp@neutralizepar{\let\par\relax}
\newcommand\csp@restorepar{\let\par\@@par}

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
			% Child columns sit side by side in this minipage, so make blank
			% lines between them harmless here too (the minipage's
			% \@parboxrestore has just reset \par to the real one).
			\csp@neutralizepar%
	}{
			% Close the column row before the minipage ends.
			\csp@restorepar\par%
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
	\IfValueT{#1}{%
		\setlength{\csp@@columnwidth}{\dimexpr (#1\csp@@currentareawidth)\relax}%
	}%
	% \setlength{\csp@@columnwidth}{\dimexpr (\textwidth)/\number\csp@columnsnum\relax}%
	\setlength{\csp@@currentareawidth}{\csp@@columnwidth}%
	\begin{lrbox}{\csp@postercolumncontent}%
		\begin{minipage}[t][\csp@@currentareaheight]{\dimexpr\csp@@columnwidth}%
			\ignorespaces
			}{%
			\end{minipage}%
		\end{lrbox}%
	% A fixed-height [t] minipage sets its baseline at the first box's baseline,
	% so columns whose first boxes differ in height get different heights above
	% the baseline. Placed side by side they share one baseline and the galley
	% line grows to max(height)+max(depth) -- much taller than the area height --
	% which then will not fit under the header and spills onto a second page.
	% Re-reference every column to a common baseline at its very top
	% (height 0, depth = area height) so all columns align and the line is
	% exactly the area height.
	\setbox\csp@postercolumncontent=\hbox{%
		\raisebox{-\ht\csp@postercolumncontent}[\z@][\csp@@currentareaheight]{%
			\usebox{\csp@postercolumncontent}}}%
	\ifcsp@frames%
		\setlength{\fboxrule}{1pt}%
		\setlength{\fboxsep}{-\fboxrule}%
		\fbox{%
	\fi%
	\usebox{\csp@postercolumncontent}%
	\ifcsp@frames}\fi%
}

% Empty, user-overridable style. Users can append keys via
% \tcbset{posterstyle/.style={...}} in their document preamble.
\tcbset{posterstyle/.style={}}

% Main appearance of a posterbox, ported from the old mdframed csp@framestyle.
\tcbset{csp@framestyle/.style={
	enhanced,
	colframe=white!20!black,
	boxrule=0.8pt,
	arc=4pt,
	% boxsep=0pt so left/right/top/bottom are the only content padding,
	% matching the old mdframed inner margins exactly (avoids extra height).
	boxsep=0pt,
	left=3mm,
	right=3mm,
	top=3mm,
	bottom=3mm,
	% Box separation is handled by the \vfill in the posterbox environment,
	% so the box's own vertical skips must be zero (cf. mdframed skipbelow=0mm).
	before skip=0mm,
	after skip=0mm,
	% Drop shadow mirroring the old mdframed shadow=true, shadowsize=6pt.
	drop fuzzy shadow=black!50!white,
	% Outer left/right margin of half the column separation: tcolorbox has no
	% direct outer-margin key, so shrink the box and centre it in the column.
	width=\dimexpr\linewidth-\postercolumnseparation\relax,
	enlarge left by=\dimexpr(\postercolumnseparation)/2\relax,
}}

\NewDocumentEnvironment{posterbox}{O{white} m O{}}{%
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternaldisable\fi%
	% Only add a header it is non-empty
	\ifstrempty{#2}{%
	\begin{tcolorbox}[csp@framestyle,
		colback=#1,
		#3,
		posterstyle]%
	}{
	% The title is typeset as the first line of the body rather than via
	% tcolorbox's title mechanism. A separate title region (colbacktitle) abuts
	% the body fill and many PDF viewers draw a hairline seam where two
	% same-coloured fills meet; keeping a single fill avoids that line entirely.
	\begin{tcolorbox}[csp@framestyle,
		colback=#1,
		#3,
		posterstyle]%
		{\ifcsp@centertitle\centering\fi\boxtitle{#2}\par}%
		% Breathing room between the title and the body content.
		\vspace{2pt}%
	}
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternalenable\fi%
	\ignorespaces
	}{%
	\ifcsname tikz@library@external@loaded\endcsname\tikzexternaldisable\fi%
	\end{tcolorbox}%[\posterboxseparator]
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
	% Box-title centering (centertitle option) is applied directly in the
	% posterbox environment via \ifcsp@centertitle, since the title is part of
	% the box body rather than a tcolorbox title.
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
	% Make the column galley immune to blank lines between environments.
	\csp@neutralizepar%
	}

% Re-arm a real \par so the final page can be shipped out.
\AtEndDocument{\csp@restorepar\par}


\endinput
