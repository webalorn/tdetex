# TDeTeX

TDeTeX helps you quickly create beautiful documents for The Dark Eye roleplaying game. The project source code is available on [github](https://github.com/webalorn/tdetex), but because it use some copyrighted elements, the github repository only contains the LaTeX code. The full project with the images and the examples is available for free on drivethrurpg.

TDeTeX works well with english, french and german, and should work with other languages.

## Installation

*Assuming you have dowloaded the full version from drivethrurpg*

First, you need to install all the fonts present in the `fonts` subdirectory on your system.

To compile with `TDeTeX`, the simpler way is to create your `.tex` file in the same directory as this project. But it will become unmanageable if you have too much file (or you will need to move the files each time).

The more efficient way is to install TDeTeX system-wide. You will find instructions on the Internet if the following steps fail:

- Open a terminal and type `kpsewhich -var-value=TEXMFHOME`. It gives you the path of a folder (`~/Library/texmf` on MacOS). Go to this folder.
- Go to the subfolder `tex/latex/` and create and move the whole directory of this project here. You should have a file at `[LATEX PATH]/tex/latex/tdetex/TDeTeX.cls` (`~/Library/texmf/tex/latex/tdetex/TDeTeX.cls` on MacOS).
- You can now create your `.tex` file anywhere and use TDeTeX !

## Usage

TDeTeX works well with `XeLaTeX`.

The documentation is available in the form of a pdf file (`tdetex_documentation.pdf`), available on drivethrurpg. The code generating this pdf is in `documentation.tex`. Here is a basic code skeletton:

```latex
\documentclass[LQ,lang=english]{TDeTeX}

\begin{document}
\titlePage{images/titlepage_image}{width=\paperwidth}{Title, line 1}{Title, line 2}
\TdeToc

\chapter{Document chapter}
\begin{twocols}
	Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque et mi quis diam laoreet volutpat in eget nisi. Donec cursus volutpat...
\end{twocols}
\end{document}
```

## License and credits

The source code is relased under the [MIT license](https://github.com/webalorn/tdetex/blob/main/LICENSE). The graphical elements as well as "The Dark Eye" belong to [Ulisses](https://ulisses-us.com/).

This project is based on [DSaTeX](https://www.ulisses-ebooks.de/product/237039/DSaTeX) by Lukas Ester, and include code from [DSA5TexLayout](https://github.com/theShmoo/DSA5TexLayout) by David Pfahler. I mostly fixed bugs, improved code and added some features. For any problem or question, you can open an issue or contact me (email address on my [profile](https://github.com/webalorn)).