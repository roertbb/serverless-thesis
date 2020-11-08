%
%  $Id: csthesis.cls 3117 2012-11-22 09:13:33Z sobaniec $
%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{csthesis}[2012/07/06 v3.0 CS Thesis class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\LoadClass{book}


\RequirePackage{geometry}
\RequirePackage[outermarks,pagestyles,clearempty,%
                psfloats,rigidchapters,newlinetospace]{titlesec}
\RequirePackage{titletoc}
\RequirePackage{dcslib}[2012/03/01]
\RequirePackage{dcsalg}
\RequirePackage[nottoc,notlot,notlof]{tocbibind}
\RequirePackage{pifont}
\RequirePackage{enumitem}


% fonts
\ifunicodeengine
  % available at http://www.fontsquirrel.com/fonts/Linux-Libertine
  \setprimaryfont[Scale=1.04]{Linux Libertine O}
  % available at http://www.fontsquirrel.com/fonts/open-sans
  \setallsansfonts[Scale=0.84]{Open Sans}
  % available at http://www.fontsquirrel.com/fonts/DejaVu-Sans-Mono
  \setallmonofonts[Scale=0.82]{DejaVu Sans Mono}
  % available at http://www.fontsquirrel.com/fonts/TeX-Gyre-Adventor
  \newfontfamily{\secfont}[Scale=1.0]{TeX Gyre Adventor}
  % http://www.fontsquirrel.com/fonts/ubuntu
  \newfontfamily{\chnfont}[Scale=1.0]{Ubuntu}
\else
  \RequirePackage[scaled=0.82]{beramono}
  \newcommand{\secfont}{\fontfamily{pag}\selectfont}
  \newcommand{\chnfont}{\fontfamily{phv}\selectfont}
\fi


% line skip
\setstretch{1.1}


% front/back matters
\renewcommand\frontmatter{%
  \cleardoublepage%
  \@mainmatterfalse%
  \pagenumbering{arabic}}
\renewcommand\mainmatter{%
  \cleardoublepage
  \@mainmattertrue}


% colors
\definecolor{seccolor}{rgb}{0.6,0.6,0.6}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{midgray}{rgb}{0.4,0.4,0.4}


\renewcommand{\and}{\par}
\renewcommand{\maketitle}{%
  \begin{titlepage}
  \secfont
  \setlength{\parindent}{0pt}
  \null\vfill
  \hfill\begin{minipage}{\textwidth}
    \begin{center}
      {\fontsize{18}{20}\selectfont\@title\par}
      \fontsize{12}{14}\selectfont
      \vspace{5mm}
      {\@author}\par
      \vspace{5mm}
      {\fontsize{10}{12}\selectfont \@date}
    \end{center}
  \end{minipage}\hspace{1cm}\hfill\null
  \vfill\null
  \end{titlepage}
  \clearpage
}


% page layout
\newlength{\headindent}
\setlength{\headindent}{2.5cm}

\geometry{a4paper,tmargin=3cm,bmargin=2.8cm,lmargin=4.5cm,rmargin=2.5cm,
          headsep=35pt,footskip=1.5cm,bindingoffset=0.5cm,
          reversemarginpar,marginparwidth=2.5cm,marginparsep=0.5cm,
          asymmetric}

% oneside
\DeclareOption{oneside}{
  \geometry{twoside=false,lmargin=5cm,rmargin=2.5cm,bindingoffset=0cm}
}


% dcsalg
\dcsalgset{boxed,number,width=0.95\textwidth,font=\small}


% heading indent
\widenhead{\headindent}{0pt}


% titlesec
\titleformat{name=\chapter}[block]{\secfont\Huge\filleft}{}{0em}%
    {\parbox{0.9\textwidth}%
       {\raggedleft\chnfont\fontsize{65}{50}\selectfont%
        \textcolor{seccolor}{\thechapter}}\vspace{0.5ex}\\}
\titleformat{name=\chapter,numberless}[block]{\secfont\Huge\filleft}{}{0em}{}
\titlespacing*{\chapter}{-\headindent}{0.5cm}{7cm}
\titleformat{\section}{\secfont\LARGE}{\thesection}{1em}{}[\titleline{\titlerule}]
\titlespacing*{\section}{-\headindent}{5ex plus 1ex minus 0.2ex}{5.5ex plus 0.5ex}

\titleformat{\subsection}{\secfont\Large}{\thesubsection}{1em}{}
\titlespacing*{\subsection}{0pt}{3.25ex plus 1ex minus 0.2ex}{1.5ex plus 0.2ex}

\titleformat{\subsubsection}{\secfont\large}{\thesubsubsection}{1em}{}

\titleformat{\paragraph}[runin]{\scshape}{}{0em}{}
\titlespacing{\paragraph}{0pt}{2.5ex plus 0.6ex minus 0.2ex}{1em}
\titleformat{\subparagraph}[runin]{\em}{}{0em}{}
\titlespacing{\subparagraph}{0pt}{2.5ex plus 0.8ex minus 0.15ex}{1em}


% toc
\titlecontents{chapter}[1.5em]{\addvspace{1.8ex}\secfont\bfseries}%
  {\contentslabel{1.5em}}{\hspace*{-1.5em}}%
  {~\hfill\contentspage}[\addvspace{0.3ex}]


% page styles
\renewpagestyle{plain}{
  \sethead{}{}{}
  \setfoot{}{}{}
}
\renewpagestyle{empty}{
  \sethead{}{}{}
  \setfoot{}{}{}
}
\newcommand{\setdefmainpagestyle}{
  \sethead[\large\usepage][]%
  [\footnotesize\itshape
    \if@mainmatter
      \ifthenelse{\value{chapter}>0}{\thechapter~~}{}
    \fi
    \chaptertitle]%
  {\footnotesize\itshape
    \if@mainmatter
      \ifthesection{\thesection~~\sectiontitle}%
                   {\ifthenelse{\value{chapter}>0}{\thechapter~~}{}\chaptertitle}
    \else
      \chaptertitle
    \fi
  }{}{\large\usepage}
  \setfoot{}{}{}
  \setfloathead{}{}{}{\setheadrule{0pt}}[p]
}
\newpagestyle{main}{\setdefmainpagestyle}

\newcommand{\workinginfo}{info}
\DeclareOption{working}{
  \renewpagestyle{plain}{
    \setfoot[\workinginfo][][]{}{}{\workinginfo}
  }
  \renewpagestyle{main}{
    \setdefmainpagestyle
    \setfoot[\workinginfo][][]{}{}{\workinginfo}
  }
}
\AtBeginDocument{
  \pagestyle{main}
  \raggedbottom
}


% lists
\setlist{itemsep=0.5\itemsep,parsep=0.5\parsep,topsep=0.7\topsep}
\setlist[enumerate,2]{label=\alph*), ref=\theenumi\alph*}
\setlist[itemize,3]{label=$\cdot$}
\renewenvironment{quote}
  {\begin{itemize}[label=]\item\relax}
  {\end{itemize}}
\renewenvironment{center}
  {\begin{itemize}[label=,leftmargin=0pt]\item\relax\centering}
  {\end{itemize}}


% labeling environment
\newenvironment{labeling}[1][]%
  {\begin{description}[font=\normalfont,style=nextline,#1]}
    {\end{description}}


% wide standard environment (extends to cover margins)
\newenvironment{widestandard}
  {\begin{itemize}[leftmargin=-\headindent,label=,topsep=0pt,partopsep=0pt,parsep=\parskip]
     \addtolength{\textwidth}{\headindent}%
     \item\relax}
  {\end{itemize}}


% marginpar
\newcommand{\mpar}[1]{\marginpar{\raggedleft\footnotesize#1}}
\newcommand{\mparnote}[1]{\mpar{\itshape\textcolor{blue}{#1}}}
\newcommand{\mcomm}[1]{\marginpar{\raggedright\itshape\footnotesize#1}}
\newcommand{\marbox}[1]{\colorbox{gray}{\textcolor{white}{%
            \textsf{\footnotesize\bfseries #1}}}}
\newcommand{\defmarker}[1]{%
  \marginpar{\raggedleft\parbox{1.5cm}{\centering\marbox{#1}}}}
\newcommand{\DEF}{\defmarker{DEF}}
\newcommand{\LEM}{\defmarker{LEM}}
\newcommand{\THM}{\defmarker{THM}}
\newcommand{\EXM}{\marginpar{\raggedleft\parbox{1.5cm}{%
  \centering\textcolor{midgray}{\framebox{\textsf{\footnotesize\bfseries EXM}}}}}}


% math spacing
\setlength{\arraycolsep}{1.4\p@}
\setlength{\extrarowheight}{0cm}
\renewcommand{\arraystretch}{0.9}
\setlength{\tabcolsep}{5\p@}
\providecommand{\mod}{\ensuremath{\:\%\:}}


% dings
\newcommand{\DG}{\ding{52}}


% floats
\setcounter{topnumber}{3}


\ProcessOptions\relax