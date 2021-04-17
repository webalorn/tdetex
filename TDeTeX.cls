\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{TDeTeX}[2020/04/16 LaTeX for The Dark Eye]
%
% Based on https://www.ulisses-ebooks.de/product/237039/DSaTeX by Lukas Ester
% I made this because the code really needed to be factorized and improved, some bugs had to be corrected, and I wanted to add english and french support as well as other features
% Some code seems to be from the Internet, but the original author did not put links to the source
% Some code comes from DSA5TexLayout (https://github.com/theShmoo/DSA5TexLayout) by David Pfahler
% Made by webalorn (webalorn@gmail.com)
%

%%%%%%%%%%%%%%%%%
% Class options %
%%%%%%%%%%%%%%%%%

\RequirePackage{xkeyval} % better option processing
\def\tdetexlanguage{english}
\def\tdetexpapersize{a4paper}
\def\tdetexfontsize{10pt}
\def\tdetextquality{LQ}

\DeclareOptionX{LQ}{\gdef\tdetextquality{LQ}}
\DeclareOptionX{HQ}{\gdef\tdetextquality{HQ}}

\DeclareOptionX{lang}{\gdef\tdetexlanguage{#1}}
\DeclareOptionX{size}{\gdef\tdetexpapersize{#1}}
\DeclareOptionX{font}{\gdef\tdetexfontsize{#1}}

\DeclareOptionX*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptionsX\relax

\PassOptionsToPackage{paper=\tdetexpapersize}{typearea}
\LoadClass[\tdetexfontsize,\tdetexpapersize]{book}


%%%%%%%%%%%%
% Packages %
%%%%%%%%%%%%

\RequirePackage[table]{xcolor}
\RequirePackage{eso-pic,graphicx,multicol,wrapfig}
\RequirePackage[top=2cm, bottom=1.7cm, includefoot,left=1.9cm,right=1.6cm,footskip=.5cm]{geometry}
\RequirePackage{mathptmx}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{titlesec}
\RequirePackage{graphicx}
\RequirePackage{wrapfig}
\RequirePackage{amssymb}
\RequirePackage{mwe,tikz}
\RequirePackage{fontspec}
\RequirePackage{array,tabularx,colortbl}
\RequirePackage[auto]{contour}% http://ctan.org/pkg/contour
\RequirePackage{textcomp}
\RequirePackage{background}
\RequirePackage{intcalc}
\RequirePackage{calc}
\RequirePackage{float,dblfloatfix}
\RequirePackage{enumitem}
\RequirePackage[percent]{overpic}
\RequirePackage{relsize}
\RequirePackage[most]{tcolorbox}
\RequirePackage{shapepar}
\RequirePackage{microtype}
\RequirePackage{polyglossia}
\RequirePackage{suffix}
\RequirePackage{fancyhdr}
\RequirePackage{tocloft}
\RequirePackage{ifthen}
\RequirePackage[T1]{fontenc}
\RequirePackage{gentium}

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configuration & globals %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

\defaultfontfeatures{Mapping=tex-text,Scale=MatchLowercase}
\usetikzlibrary{calc,fit,intersections}
\usetikzlibrary{shapes.arrows, fadings}

\renewcommand{\cftpartleader}{\cftdotfill{\cftdotsep}} % for parts
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % for 

\newcommand{\imgsrc}[1]{graphic_elements/#1_\tdetextquality}


% \fontspec{Andalus}
% \newfontfamily{\andalusfont}{Andalus}[
% Path            =   fonts/andalus/,
% Extension       =   .ttf,
% UprightFont     =   *-regular,
% ]
% \newfontfamily{\gentiumfont}{gentium}[
% Path            =   fonts/gentium/,
% Extension       =   .ttf,
% UprightFont     =   *-regular,
% BoldFont        =   *-bold,
% ItalicFont      =   *-italic,
% BoldItalicFont  =   *-bolditalic
% ]


\definecolor{optionalhead}{RGB}{89,89,89}
\definecolor{optionalbody}{RGB}{174,174,174}

% Colors from DSA5TexLayout
\definecolor{bgtan}{HTML}{F7F2E5}   % e.g. used for background and quotebox
\definecolor{titlered}{HTML}{58180D}  % e.g. used for titles
\definecolor{undergold}{HTML}{C9AD6A} % e.g. used for titlerules
\definecolor{uppergold}{HTML}{B89A67} %e.g. used for pagenumbers and footer
\definecolor{puregold}{HTML}{E69A28}  %e.g. used for top line in newer monsterbox
\definecolor{monstertan}{HTML}{FDF1DC}  %e.g. used for newer monsterblock
\definecolor{monstertandark}{HTML}{F0DBB5}  %e.g. used for older monsterbox
\definecolor{commentgreen}{HTML}{E0E5C1} % e.g. used in table and green commentbox
\definecolor{itemtablepink}{HTML}{E9CDC2} % e.g. used in item tables instead of the green
\definecolor{rulered}{HTML}{9C2B1B}   %e.g. used for triangular rule in statsblock

% TDE colors from DSA5TexLayout
\definecolor{footercolor}{HTML}{FFFFFF}
\definecolor{commentboxcolor}{HTML}{FFFFFF}
\definecolor{tableheadercolor}{HTML}{E69A28}
\definecolor{tablelinecolor}{HTML}{E69A28}

% TDE colors
\definecolor{tdeBrown}{RGB}{132,60,11}
\definecolor{tdeGrey}{RGB}{83,83,83}
\definecolor{tdeLightGrey}{RGB}{94,94,94}
\definecolor{tdeLighterGrey}{RGB}{220,220,220}
\definecolor{tdeRed}{RGB}{192,0,0}
\definecolor{tdeLightRed}{RGB}{205,151,135}
\definecolor{tdeGreen}{RGB}{56,87,36}
\definecolor{tdeBlue}{RGB}{31,78,121}
\definecolor{tdeGold}{RGB}{214,173,120}

% \definecolor{tdeGold}{RGB}{214,173,120}

%%%%%%%%%%%%
% Language %
%%%%%%%%%%%%

\setdefaultlanguage{\tdetexlanguage}

\ifthenelse{\equal{\tdetexlanguage}{french}}{
  \def\bytextendpage{par}
}{
\ifthenelse{\equal{\tdetexlanguage}{german}}{
  \def\bytextendpage{von}
}{
  \def\bytextendpage{by}
}
}

%%%%%%%%%%%
% Utility %
%%%%%%%%%%%

\def\shapeparnodeaccuracy{2}
\newcommand\shapeparnode[6][]{
  % 6 parameters:
  % style for node (default:empty),
  % h margin, v margin, left path, right path, text (just one paragraph!)

  % name left and right paths and compute there bounding boxes
  \begin{scope}[local bounding box=leftbb]
    \path[name path global=left,xshift=#2] #4;
  \end{scope}
  \node[inner ysep=-#3,inner xsep=0pt,fit=(leftbb)](leftbb){};
  \begin{scope}[local bounding box=rightbb]
    \path[name path global=right,xshift=-#2] #5;
  \end{scope}
  \node[inner ysep=-#3,inner xsep=0pt,fit=(rightbb)](rightbb){};

  % global bounding box
  \path let
  \p1=(leftbb.north west), \p2=(leftbb.south west),
  \p3=(rightbb.north east), \p4=(rightbb.south east)
  in
  \pgfextra{
    \pgfmathsetmacro{\ymin}{(\y1 < \y3) ? \y1 : \y3}
    \pgfmathsetmacro{\ymax}{(\y2 > \y4) ? \y2 : \y4}
    \typeout{ymin \ymin}
    \typeout{ymax \ymax}
  } node[inner sep=0,fit={(\x1,\ymin pt)(\x3,\ymax pt)}](mybb){};

  % compute nb steps
  \path let \p1=(mybb.north), \p2=(mybb.south) in
  \pgfextra{
    \pgfmathsetmacro{\fnthght}{1em/\shapeparnodeaccuracy}
    \pgfmathtruncatemacro{\nbsteps}{(\y1-\y2)/\fnthght}
    \xdef\nbsteps{\nbsteps}
    \typeout{nb steps \nbsteps}
  };

  % horizontal references
  \path (mybb.north) -- (mybb.south)
  \foreach \cnt in {0,1,...,\nbsteps}{
    \pgfextra{\pgfmathsetmacro{\pos}{\cnt/\nbsteps}}
    coordinate[pos=\pos] (ref \cnt)
  };

  % left and right boundaries coordinates
  \foreach \cnt in {0,1,...,\nbsteps}{
    % an horizontal line from left to right
    \path[name path=ltor]
    (mybb.west |- ref \cnt) --  (mybb.east |- ref \cnt);
    % same line from right to left
    \path[name path=rtol]
    (mybb.east |- ref \cnt) -- (mybb.west |- ref \cnt);
    % left boundary
    \path[name intersections={of=rtol and left,by={l \cnt},sort by=rtol}];
    % right boundary
    \path[name intersections={of=ltor and right,by={r \cnt},sort by=ltor}];
  }
  % start point (and initial value of boundshape)
  \path let \p1=(l 0) in 
  \pgfextra{
    \pgfmathsetmacro{\xstart}{\x1}
    \xdef\boundshape{{0}{0}b{\xstart}}
    \xdef\xmin{\xstart}
    \xdef\xmax{\xstart}
  };

  % top and bottom
  \path let \p1=(l 0), \p2=(l \nbsteps) in
  \pgfextra{
    \pgfmathsetmacro{\ystart}{\y1}\xdef\ystart{\ystart}
    \pgfmathsetmacro{\yending}{\y2}\xdef\yending{\yending}
  };
  % incremental definition of boundshape
  \foreach \cnt in {0,1,...,\nbsteps}{
    \path let \p1=(l \cnt), \p2=(r \cnt) in
    \pgfextra{
      \pgfmathsetmacro{\start}{\x1}
      \pgfmathsetmacro{\len}{\x2-\x1}
      \pgfmathsetmacro{\ypos}{\cnt/\nbsteps*(\ystart - \yending)}
      {\let\\=\relax \xdef\boundshape{\boundshape\\{\ypos}t{\start}{\len}}}
      \pgfmathsetmacro{\xmin}{(\xmin < \start) ? \xmin : \start}
      \xdef\xmin{\xmin}
      \pgfmathsetmacro{\xmax}{(\xmax > \start + \len) ? \xmax : \start + \len}
      \xdef\xmax{\xmax}
    };
  }
  % draw the node with text in a shapepar
  \pgfmathsetmacro{\ymax}{\ystart - \yending}
  {\let\\=\relax \xdef\boundshape{\boundshape\\{\ymax}e{0}}}
  \node[#1,text width=\xmax pt - \xmin pt,align=flush left,
  anchor=north west,inner sep=0]
  at (mybb.north west -| \xmin pt,0)
  {\Shapepar[1pt]{\boundshape}#6\par};
}

\def\gobblechar{\let\xchar= }
\def\assignthencheck{\afterassignment\xloop\gobblechar}
\def\xloop{%
  \ifx\relax\xchar
      \let\next=\relax
    \else
      \dsashadowtext{white}{black}{\xchar}\let\next=\assignthencheck
  \fi
  \next}
\def\markletters#1{\assignthencheck#1\relax}


%%%%%%%%%%%%%%%%%%%%%%
% Document formating %
%%%%%%%%%%%%%%%%%%%%%%

% Background
\providecommand{\BGsideLetter}{\ifodd\value{page}L\else%
R\fi}
\backgroundsetup{
  scale=1,
  opacity=1,
  angle=0,
  color=black,
  contents={%
   \AddToShipoutPictureBG*{\includegraphics[width=\paperwidth]{\imgsrc{\BGsideLetter_side_\intcalcMod{\intcalcDiv{\value{page}}{2}}{3}}}}
  }
}

% Putting shadow onto letters
\newcommand\titleShadow[3]{%
  \begin{tikzpicture}
      \draw[every node/.style={text=#1}]
       (0,0)         coordinate (text destination)
    ++ (0,-0.05em)         coordinate (shadow destination)
       % Blur
       \foreach \x [count=\i] in {5.0,6.0,...,10} {%0.0,10.1,...,30
          (shadow destination) node[#2, opacity=0.03 ] {\contournumber{30}\contourlength{\x pt}\contour{#2}{\fontsize{50}{60}\selectfont\bf{#3}}}
        }
      % Main Shadow
      %(shadow destination) node[#2] {#3};
      (text destination)   node[#1, opacity=1] {\fontsize{50}{60}\selectfont\bf{#3}};
  \end{tikzpicture}
}

\newcommand\dsashadowtext[3]{%
\begin{tikzpicture}
    \draw[every node/.style={text=#1}]
     (0em,-0em)         coordinate (text destination)
  ++ (0em,-0.1em)         coordinate (shadow destination)
     % Blur
     \foreach \x [count=\i] in {1.0,1.2,...,4} {%0.0,10.1,...,30
        (shadow destination) node[#2, opacity=0.02 ] {\contournumber{20}\contourlength{\x pt}\contour{black}{\fontsize{22}{22}\selectfont\bf{#3}}}
      }
    % Main Shadow
    %(shadow destination) node[#2] {#3};
    (text destination)   node[#1, opacity=1] {\fontsize{20}{20}\selectfont\bf{#3}};
\end{tikzpicture}
}

\newcommand\chariterate[2][c]{\if w#1\worditeratehelper#2 \relax\relax\else
  \chariteratehelpA#2 \relax\relax\fi}
\def\chariteratehelpA#1 #2\relax{%
  \chariteratehelpB#1\relax\relax%
  \ifx\relax#2\else\ \chariteratehelpA#2\relax\fi
}
\def\chariteratehelpB#1#2\relax{%
  \charop{#1}%
  \ifx\relax#2\else
    \chariteratehelpB#2\relax%
  \fi
}
\def\worditeratehelper#1 #2\relax{%
  \wordop{#1}%
  \ifx\relax#2\else\ \worditeratehelper#2\relax\fi
}
 
\newcommand\charop[1]{\titleShadow{white}{black}{#1}}%
\def\wordop#1{#1}

\def\gobblechar{\let\xchar= }
\def\assignthencheck{\afterassignment\xloop\gobblechar}
\def\xloop{%
  \ifx\relax\xchar
    \let\next=\relax
  \else
    \dsashadowtext{white}{black}{\xchar}\let\next=\assignthencheck
  \fi
  \next}
\def\markpagenumbers#1{\assignthencheck#1\relax}

\pagestyle{fancy}
\fancyhf{} % clear all footer fields
\renewcommand{\headrulewidth}{0.0pt} %no rule for header
\renewcommand{\footrulewidth}{0.0pt} %no rule for footer

% Footer
\fancyfoot[LO]{
  \vspace*{.5cm}
  % \hspace*{0.2cm}
  % \hspace*{0.2cm}
  \ifnum\value{page}>9
    \hspace*{-0.4cm}
  \else\fi
  \markpagenumbers{\thepage}
  %\raisebox{12pt}{\textsc{\textcolor{white}{\nouppercase\leftmark}}}
}
 
\fancyfoot[RE]{
  %\raisebox{12pt}{\textsc{\textcolor{white}{\nouppercase\leftmark}}}
  %\hspace*{1cm}
  \vspace*{.5cm}
  \markpagenumbers{\thepage}
  \ifnum\value{page}>9
    \hspace*{-0.7cm}
  \else
    \hspace*{-0.35cm}
  \fi
}

% Chapter heading
\renewcommand{\chapter}{%
  \@ifstar {\@dblarg\my@chapterNoNum}{\@dblarg\my@chapter}%
}
\newcommand{\internalShowChapter}[1]{
  \begin{tikzpicture}[overlay]
  \node[anchor=north west, inner sep=0] (X) at (-6em,3em){\includegraphics[width=1.1\paperwidth]{\imgsrc{chapter_start_banner}}};%
  \begin{scope}[x={(X.south east)},y={(X.north west)}]
  \node[text width=.9\textwidth, anchor=center, align=left] (Z) at (0.45,0.4) {\fontspec{Andalus}\fontsize{31.7}{31.7}\selectfont #1};
  \end{scope}%
  \end{tikzpicture}
  \vspace*{4cm}\\
}
\newcommand*{\my@chapterNoNum}[2][]{%
  \internalShowChapter{#1}
}
\newcommand*{\my@chapter}[2][]{%
  \stepcounter{chapter}
  \internalShowChapter{\chaptername \thechapter:\\#1}
  \addcontentsline{toc}{chapter}{#1}
}

% Sections formats
\titleformat{\section}[display]{\fontspec{Andalus}\fontsize{30}{30}\selectfont}{}{0pt}{}
\titleformat{\subsection}[display]{\fontspec{Gentium Basic}\fontsize{15}{15}\bfseries\selectfont}{}{0pt}{} 
\titleformat{\subsubsection}[display]{\fontspec{Gentium Basic}\fontsize{12.0}{12.0}\bfseries\selectfont}{}{0pt}{}


%%%%%%%%%%%%
% Commands %
%%%%%%%%%%%%

\newenvironment{twocols}
{\begin{multicols*}{2}
  \raggedcolumns}
{\end{multicols*}}

\newcommand\tdefig[1]{%
  \medskip\noindent\begin{minipage}{\columnwidth}
    \centering%
    #1
  \end{minipage}\medskip}

\newtcolorbox{smallParchment}[1][]{
	unbreakable,
    blankest,
    top=10mm,
    left=10mm,
    right=10mm,
    bottom=10mm,
    watermark graphics=\imgsrc{small_parchment}, 
    watermark stretch=1,
    width=.9\linewidth,
    height=.5338\linewidth,
    #1	
}
\newtcolorbox{mediumParchment}[1][]{
	unbreakable,
    blankest,
    top=10mm,
    left=10mm,
    right=10mm,
    bottom=10mm,
    watermark graphics=\imgsrc{medium_parchment}, 
    watermark stretch=1,
    width=.9\linewidth,
    height=1.047\linewidth,
    #1	
}
\newtcolorbox{longParchment}[1][]{
	unbreakable,
    blankest,
    top=10mm,
    left=10mm,
    right=10mm,
    bottom=10mm,
    watermark graphics=\imgsrc{long_parchment}, 
    watermark stretch=1,
    width=0.9\linewidth,
    height=2.025\linewidth,
    #1	
}

\newtcolorbox{smallMasterBox}[1][]{
	unbreakable,
    blankest,
    top=5mm,
    left=5mm,
    right=5mm,
    bottom=5mm,
    watermark graphics=\imgsrc{small_master_box}, 
    watermark stretch=1,
    width=0.9\linewidth,
    height=0.578\linewidth,
    coltext=white,    
    #1
}

\newtcolorbox{masterBox}[1][]{
	unbreakable,
    blankest,
    top=5mm,
    left=5mm,
    right=5mm,
    bottom=5mm,
    watermark graphics=\imgsrc{master_box},
    watermark stretch=1,
    width=.9\linewidth,
    height=1.717\linewidth,
    coltext=white,
    #1
}
\newtcolorbox{wideMasterBox}[1][]{
  unbreakable,
    blankest,
    top=5mm,
    left=5mm,
    right=5mm,
    bottom=5mm,
    watermark graphics=\imgsrc{wide_master_box},
    watermark stretch=1,
    width=.9\linewidth,
    height=1.717\linewidth,
    coltext=white,
    #1
}

\newtcolorbox{smallInfo}[1][]{
	unbreakable,
    blankest,
    top=10mm,
    left=10mm,
    right=10mm,
    bottom=10mm,
    watermark graphics=\imgsrc{small_info_box}, 
    watermark stretch=1,
    width=\linewidth,
    height=.649\linewidth,
    #1
}

\newtcolorbox{mediumInfo}[1][]{
	unbreakable,
    blankest,
    top=10mm,
    left=10mm,
    right=10mm,
    bottom=10mm,
    watermark graphics=\imgsrc{medium_info_box}, 
    watermark stretch=1,
    width=\linewidth,
    height=1.195\linewidth,
    #1
}
\newtcolorbox{largeInfo}[1][]{
  unbreakable,
    blankest,
    top=10mm,
    left=10mm,
    right=10mm,
    bottom=10mm,
    watermark graphics=\imgsrc{large_info_box}, 
    watermark stretch=1,
    width=\linewidth,
    height=2.319\linewidth,
    #1
}

\newtcolorbox{quotebox}[1][]{enhanced jigsaw,frame hidden,boxrule=0pt,
  breakable,
  enhanced,
  before skip=10pt plus 1pt,
  boxsep=0.25ex,
  left=8pt,
  right=8pt,
  colback=bgtan,
  colframe=bgtan,
  arc=0mm,
  parbox = false,
  borderline west={1pt}{-0.5pt}{titlered},
  borderline east={1pt}{-0.5pt}{titlered},
  fontupper = \fontfamily{lmss}\selectfont,
  overlay={
    \foreach \n in {north east,north west,south east,south west}
    {\draw [titlered, fill=titlered] (frame.\n) circle (2pt); }; },
  after={\vspace{7.5pt plus 1pt}\noindent},
  #1
}

% Parameters : {title}{} OR {title}{subtitle} OR [tcolorbox parameters]{title}{subtitle or empty}
\newtcolorbox{optional}[3][]{
  unbreakable,
  skin=bicolor,
  colback=optionalbody,
  colbacktitle=optionalhead,
  bottom=0mm,
  boxrule=0pt,
  arc=0pt,
  outer arc=0pt,
  left=2pt,
  right=2pt,
  top=2pt,
  bottom=2pt,
  center,
  title={\large{#2}\ifthenelse{\equal{#3}{}}{}{\\\emph{#3}}},
  #1
}




\newcommand\AtPageUpperRight[1]{\AtPageUpperLeft{%
   \makebox[\paperwidth][r]{#1}}}
\providecommand{\topRightCorner}{
  \AddToShipoutPictureFG*{
    \AtPageUpperRight{%
      \raisebox{-\height}{%
        \includegraphics[width=0.3\paperwidth]{\imgsrc{corner_top_right}}%
      }%
    }%
  }
}
\providecommand{\topLeftCorner}{
  \AddToShipoutPictureFG*{
    \AtPageUpperLeft{%
      \raisebox{-\height}{%
        \includegraphics[width=0.3\paperwidth]{\imgsrc{corner_top_left}}%
      }%
    }%
  }
}

% Argument : {path of image}
\providecommand{\portraitLeftTop}[1]{
  \AddToShipoutPictureFG*{
    \begin{tikzpicture}[overlay]
      \node[circle,path picture={\node at (path picture bounding box.center){\includegraphics[width=0.1\paperwidth]{#1}};},minimum size=.1\paperwidth] at (.08\paperwidth,\paperheight-0.097\paperwidth){};
      \node at (.135\paperwidth,\paperheight-0.15\paperwidth) {\includegraphics[width=.3\paperwidth]{\imgsrc{portrait_left_top}}};
    \end{tikzpicture}     
  }   
}

% Argument : {path of image}
\providecommand{\portraitRightTop}[1]{
   \AddToShipoutPictureFG*{
     \begin{tikzpicture}[overlay]
      \node[circle,path picture={\node at (path picture bounding box.center){\includegraphics[width=.1\paperwidth]{#1}};},minimum size=.1\paperwidth] at (.917\paperwidth,\paperheight-0.097\paperwidth){};
      \node at (.856\paperwidth,\paperheight-0.15\paperwidth) {\includegraphics[width=.3\paperwidth]{\imgsrc{portrait_right_top}}};
    \end{tikzpicture}     
  }
}


% Arguments: {path of background image} {background image options} {Title line 1} {Title line 2}
\providecommand{\titlePage}[4]{  
  \NoBgThispage
  \pagenumbering{gobble}
  %Titelseite
  \begin{tikzpicture}[overlay, remember picture]
       \node[anchor=center] at (current page.center) {\includegraphics[#2]{#1}}; % Backgound image of the front page
       \node[anchor=north west] at (current page.north west) {\includegraphics[width=1.01\paperwidth,height=1.01\paperheight]{\imgsrc{ScriptoriumAventuris_front}}};
       \node[inner sep=-4.5,outer sep=-4.5] at (.39\paperwidth,-.7\paperheight) {         {\fontsize{50}{60}\selectfont \chariterate{#3}} };
       \node[inner sep=-4.5,outer sep=-4.5] at (.39\paperwidth,-.765\paperheight) {         {\fontsize{50}{60}\selectfont \chariterate{#4}} };
    \end{tikzpicture}
  \clearpage
  %\setcounter{chapter}{1}
  \setcounter{tocdepth}{2}
  \pagenumbering{arabic}
}    

% Arguments: {text} {image path}
\providecommand{\smallInfoPortrait}[2]{% 
  \begin{tikzpicture}%
    \node [anchor=north west] (X) at (-1,1){\includegraphics[width=.49\textwidth]{\imgsrc{small_info_box_with_portrait}}};%
    \node[circle,path picture={\node at (path picture bounding box.center){\includegraphics[width=.1\paperwidth]{#2}};},minimum size=.092\paperwidth] at (6.13,-0.78){};
    \def\pathone{(-0.2,-0.3)  to (-0.2,-4)}
    \def\pathtwo{(7,-4) to (7,-2.5) arc(280:160:1.9)}
    \shapeparnode{1em}{.2em}{\pathone}{\pathtwo}{#1}
  \end{tikzpicture}\\
}

 
% Arguments: {text} {image path}
\providecommand{\mediumInfoPortrait}[2]{% 
\begin{tikzpicture}%
\node [anchor=north west] (X) at (-1,1){\includegraphics[width=.49\textwidth]{\imgsrc{medium_info_box_portrait}}};%
\node[circle,path picture={\node at (path picture bounding box.center){\includegraphics[width=.1\paperwidth]{#2}};},minimum size=.92\paperwidth] at (6.06,-0.68){};
  \def\pathone{(0,0)  to (0,-9)}
  \def\pathtwo{(7,-9) to (7,-2.4) arc(280:160:1.9)}
  \shapeparnode{1em}{.2em}{\pathone}{\pathtwo}{#1}	
\end{tikzpicture}\\}

% Arguments: {text} {image path}
\providecommand{\largeInfoPortrait}[2]{% 
\begin{tikzpicture}%
\node [anchor=north west] (X) at (-1,1){\includegraphics[width=.49\textwidth]{\imgsrc{large_info_box_portrait}}};%
\node[circle,path picture={\node at (path picture bounding box.center){\includegraphics[width=.1\paperwidth]{#2}};},minimum size=.092\paperwidth] at (6.1,-0.66){};
  \def\pathone{(0,0)  to (0,-9)}
  \def\pathtwo{(7,-9) to (7,-2.4) arc(280:160:1.9)}
  \shapeparnode{1em}{.2em}{\pathone}{\pathtwo}{#1}  
\end{tikzpicture}\\}


% Argument: {text}
\providecommand{\ruleBox}[1]{
\begin{tikzpicture}
\node[anchor=south west, inner sep=0] (X) at (0,0){\includegraphics[width=.4\textwidth,height=.2\paperheight]{\imgsrc{small_master_box}}};%
\begin{scope}[x={(X.south east)},y={(X.north west)}]%
\node[anchor=center] at (0.5,1) {\includegraphics[width=.47\textwidth]{\imgsrc{paragraph_separator_top}}};
\node[anchor=center] at (0.5,0) {\includegraphics[width=.47\textwidth]{\imgsrc{paragraph_separator_bottom}}};
\node[text width=.35\textwidth,  anchor=north west, align=justify] (Z) at (0.05,0.95) {\color{white}#1\selectfont};
\end{scope}%
\end{tikzpicture}
}

% Argument: {text}
\providecommand{\maskBox}[1]{
\begin{tikzpicture}
\node[anchor=south west, inner sep=0] (X) at (0,0){\includegraphics[width=.4\textwidth,height=.2\paperheight]{\imgsrc{small_master_box}}};%
\begin{scope}[x={(X.south east)},y={(X.north west)}]%
\node[anchor=center] at (0.5,1) {\includegraphics[width=.47\textwidth]{\imgsrc{paragraph_separator_top}}};
\node[anchor=center] at (0.5,0) {\includegraphics[width=.47\textwidth]{\imgsrc{paragraph_divider_bottom_mask}}};
\node[text width=.35\textwidth,  anchor=north west, align=justify] (Z) at (0.05,0.95) {\color{white}#1\selectfont};
\end{scope}%
\end{tikzpicture}
}

\providecommand{\whiteEye}{\smash{\raisebox{0.25\height}{\includegraphics[width=0.3cm]{\imgsrc{white_eye}}}}}
\providecommand{\darkEye}{\smash{\raisebox{0.25\height}{\includegraphics[width=0.3cm]{\imgsrc{dark_eye}}}}}

% Argument: {some characters (ex: I, II, ...)}
\providecommand{\focusRule}[1]{
{\smash{\raisebox{-0.4\height}{
\begin{tikzpicture}
	\node {\includegraphics[width=2cm]{\imgsrc{focus_rule}}};
	\node {#1};
\end{tikzpicture}
}}}
}


% Arguments: {1, 2, 3 or 4} {width}
\providecommand{\ratingRed}[2]{
\includegraphics[width=#2]{\imgsrc{rating_red_#1}}
}
% Arguments: {1, 2, 3 or 4} {width}
\providecommand{\rautenGreen}[2]{
\includegraphics[width=#2]{\imgsrc{rating_green_#1}}
}

% Arguments: {background image} {page page title} {author} {back page 1st text} {back page 2nd text} {back page bottom text}
\providecommand{\lastPage}[6]{
  \clearpage
  \pagenumbering{gobble}
  \thispagestyle{empty}
  \ClearShipoutPicture
  \backgroundsetup{contents={}}
  \AddToShipoutPictureBG*{
    \noindent\begin{tikzpicture}[remember picture, overlay]
      \node[anchor=center] at (current page.center) {\includegraphics[width=\paperwidth,height=\paperheight]{\imgsrc{ScriptoriumAventuris_back}}};
      \ifx&#1&%
      \else
        \node[anchor=center] at (current page.center) {\includegraphics[width=\paperwidth,height=\paperheight]{#1}};  
      \fi
    \end{tikzpicture}
  }
  \vspace{3cm}% \\
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=north west,font=\LARGE] at (0cm,-2.5cm) {\textbf{#2}};
    
    \node[anchor=north west] at (0cm,-3.2cm) {\bytextendpage #3}; % TODO : text
    \draw[anchor=north west,thick] (2cm,-4.2cm) -- (6cm,-4.2cm);
    \node[anchor=north west,text width=0.5\textwidth,text depth=0.565\textwidth,align=left] at (0cm,-4.6cm) {#4};
    
    \node[anchor=north west,text width=0.55\textwidth,text depth=0.565\textwidth,align=left] at (0cm,-11cm) {#5};
  \end{tikzpicture}\\
  \AddToShipoutPictureFG*{
    \begin{tikzpicture}[remember picture,overlay]
      \node[anchor=south] at (current page.south) {\includegraphics[width=.4\textwidth]{\imgsrc{last_page_field}}};
      \node [anchor=south] at (current page.south) {\includegraphics[width=.565\textwidth]{\imgsrc{bottom_border}}};
      \node[anchor=south,text width=0.35\textwidth,text depth=0.565\textwidth,align=left] at (current page.south) {#6};
    \end{tikzpicture}
  }
}




\providecommand{\pawn}{\smash{\raisebox{-0.15\height}{\includegraphics[width=0.3cm]{\imgsrc{pawn_icon}}}}}
\providecommand{\knight}{\smash{\raisebox{-0.15\height}{\includegraphics[width=0.3cm]{\imgsrc{knight_icon}}}}}
\providecommand{\tower}{\smash{\raisebox{-0.15\height}{\includegraphics[width=0.3cm]{\imgsrc{tower_icon}}}}}
\providecommand{\king}{\smash{\raisebox{-0.15\height}{\includegraphics[width=0.3cm]{\imgsrc{king_icon}}}}}
\newlist{eyetemize}{itemize}{4}
\setlist[eyetemize,1]{
  leftmargin=\dimexpr0.5cm+\labelsep\relax,
  label={\smash{\raisebox{-0.25\height}{\includegraphics[width=0.6cm]{\imgsrc{enum_eye}}}}}
}

% TODO
% \providecommand{\floatleft}[1]{}

% Argument : {wrapfigure argument (L, R, ...)}
\providecommand{\flask}[1]{
  \begin{wrapfigure}{#1}{1.2cm}
  \centering
  \vspace{-15pt} % Why ??
  \includegraphics[width=1.3cm]{\imgsrc{flask_simple}}
  \vspace{-30pt}
  \end{wrapfigure}
}
% Argument : {wrapfigure argument (L, R, ...)}
\providecommand{\skull}[1]{
  \begin{wrapfigure}{#1}{1.2cm}
  \centering
  \vspace{-15pt}
  \includegraphics[width=1.3cm]{\imgsrc{skull_difficult}}
  \vspace{-30pt}
  \end{wrapfigure}
}

% Argument : {name of separator file (mask, ...)}
\providecommand{\separator}[1]{\tdefig{\includegraphics[width=.6\textwidth]{\imgsrc{separators/#1}}}}
% Argument : [width (optional)]
\providecommand{\scriptorium}[1][.6\textwidth]{\tdefig{\includegraphics[width=#1]{graphic_elements/DSA5_Scriptorium_Aventuris_Logo.png}}}


% Seems bugged
% \newcommand{\summaryKasten}[9]{
% \begin{tikzpicture}
%   \def\pathone{(-1.9,0)  to (-1.9,-1)}
%   \def\pathtwo{(5.3,-1) to (5.3,0)}
%   \shapeparnode{1em}{.2em}{\pathone}{\pathtwo}{#1}
% \draw[thick] (-1.7cm,-.9cm) -- (4cm,-.9cm);
% \node at (-1.7,-1.0){\textbf{Genre:} #2};
% \node at (-1.7,-1.4){\textbf{Voraussetzungen:} #3};
% \node at (-1.7,-1.8){\textbf{Ort:} #4};
% \node at (-1.7,-2.2){\textbf{Zeit:} #5};
% \node at (-1.7,-2.6){\textbf{Komplexizität(Spieler/Meister):} #6};
% \node at (-1.7,-3.0){\textbf{Erfahrung:} #7};
% \node at (-1.8,-3.4){#8};%Table
%   \def\pathone{(-1.9,-6)  to (-1.9,-8.3)}
%   \def\pathtwo{(5.3,-6) to (5.3,-8.3)}
%   \shapeparnode{1em}{.2em}{\pathone}{\pathtwo}{#9}
% \end{tikzpicture}}

% Seems bugged
% \newcommand{\sumTable}[4]{
% \begin{tikzpicture}
% \node at (-1.3,-0.5){\textbf{Wichtige Fertigkeiten:}};
% \node at(-1.3,-1){Handwerk};
% \node at(3,-1){\rautenRot{#1}{.06\textwidth}};
% \node at(-1.3,-1.4){Körpertalente};
% \node at(3,-1.4){\rautenRot{#2}{.06\textwidth}};
% \node at(-1.3,-1.8){Kampf};
% \node at(3,-1.8){\rautenRot{#3}{.06\textwidth}};
% \node at(-1.3,-2.2){\textbf{Lebendige Geschichte}};
% \node at(3,-2.2){\rautenGrün{#4}{.06\textwidth}};
% \end{tikzpicture}}

% Argument : {image path}
\newcommand{\chapterImage}[1]{%	 
	\begin{tikzpicture}[overlay,remember picture]
     \node[anchor=south east] at (.845\paperwidth,-.625\paperheight) {\includegraphics[height=.85\paperheight,width=.405\paperwidth]{#1}};
     \node[anchor=south east] at (.91\paperwidth,-.72\paperheight) {\includegraphics[height=.95\paperheight]{\imgsrc{chapter_start}}};
  \end{tikzpicture}
}


\makeatletter
\newcommand{\TdeToc}{%
  \noindent\textbf{\Huge\contentsname}
  \vspace{2em}

  \@starttoc{toc}
  \newpage
}
\makeatother


% \tikzfading[name=fade right, left color=transparent!0, right color=transparent!0]
\tikzfading[name=fade right, left color=transparent!0, right color=transparent!100]

% Arguments : {color} {title}
\newcommand{\fadeSection}[2]{
  \stepcounter{section}
  \fadeSection*{#1}{#2}
  \addcontentsline{toc}{section}{#2}
}
\newcommand{\fadeSubSection}[2]{
  \stepcounter{subsection}
  \fadeSubSection*{#1}{#2}
  \addcontentsline{toc}{subsection}{#2}
}

\WithSuffix\newcommand\fadeSection*[2]{
  \bigskip
  \noindent\begin{tikzpicture}[scale=1]
    \fill[#1,path fading=fade right] (0,0) rectangle (\linewidth,2.5em);
    \node[anchor=south west] at (0.5em,0.5em) {\fontspec{Andalus}\fontsize{14}{14}\selectfont\bf{#2}};
  \end{tikzpicture}
}
\WithSuffix\newcommand\fadeSubSection*[2]{
  \medskip
  \noindent\begin{tikzpicture}[scale=1]
    \fill[#1,path fading=fade right] (0,0) rectangle (\linewidth,2em);
    \node[anchor=south west] at (0.5em,0) {\fontspec{Gentium Basic}\fontsize{13}{13}\selectfont\bf{#2}};
  \end{tikzpicture}
}

\newcommand{\fadeSectionNum}[2]{
  \fadeSection{#1}{\thesection\ #2}
}
\newcommand{\fadeSubSectionNum}[2]{
  \fadeSubSection{#1}{\thesubsection\ #2}
}


% Table Header
\newcommand{\dsatablecaption}[1]{{
  \par\vspace*{8pt}
  \noindent
  \sffamily\bfseries\scshape
  #1}}

% Fancy DSA 5 header
\newcommand{\dsaheader}[1]{%
\begin{tikzpicture}[remember picture,overlay]
  \fill[#1, path fading=fade right] (-0.65em,-0.45em) rectangle (0.98\textwidth,1em);
\end{tikzpicture}%
}

% Centered Column
\newcolumntype{Y}{>{\centering\arraybackslash}X}
% Left aligned Column
\newcolumntype{L}{>{\raggedleft\arraybackslash}X}

\newtcolorbox{dsatable}[1][]{
  blankest,
  arc=0mm,
  % width=\linewidth,
  colframe=tdeLightGrey,
  coltitle=black,
  center title,
  center,
  #1
}

\endinput