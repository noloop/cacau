# cacau

<p align="center">
  <img width="500" height="500" src="./images/cacau-logo-background-white.png">
</p>

### _Test Runner in Common Lisp._

Read this in other languages: [English](https://github.com/noloop/cacau/blob/master/README.md), [Portuguese-br](https://github.com/noloop/cacau/blob/master/README.pt-br.md)

## Getting Started in cacau

### Portability

Testei apenas no Linux usando o SBCL, em breve irei providenciar testes nas demais plataformas utilizando alguma ferramente CI.

### Dependencies

[:eventbus](https://github.com/noloop/eventbus)
[:assertion-error](https://github.com/noloop/assertion-error)

### Download and Load

**1 - Load cacau system by quicklisp**

```
IN PROGRESS...
```

**2 - Download and load cacau system by github and asdf**

download from github:

```
git clone https://github.com/noloop/cacau.git
```

and load by asdf:

```lisp
(asdf:load-system :cacau)
```

_**Note: Remember to configure asdf to find your directory where you downloaded the libraries (asdf call them "systems") above, if you do not know how to make a read at: https://common-lisp.net/project/asdf/asdf/Configuring-ASDF-to-find-your-systems.html or https://lisp-lang.org/learn/writing-libraries.**_

## Quickstart

## API

function **(lib-function-name args)**

### LICENSE

Copyright (C) 2019 noloop

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Contact author:

noloop@zoho.com

