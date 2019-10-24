# cacau

<p align="center">
  <img width="500" height="500" src="./images/cacau-logo-background-white.png">
</p>

### _Corredor de teste em Common Lisp._

Leia em outras linguagens: [English](https://github.com/noloop/cacau/blob/master/README.md), [Portuguese-br](https://github.com/noloop/cacau/blob/master/README.pt-br.md)

## Começando na cacau

### Portabilidade

Testei apenas no Linux usando o SBCL, em breve irei providenciar testes nas demais plataformas utilizando alguma ferramente CI.

### Dependências

[:eventbus](https://github.com/noloop/eventbus)
[:assertion-error](https://github.com/noloop/assertion-error)

### Download e Load

**1 - Carregue o sistema cacau com o quicklisp**

```
IN PROGRESS...
```

**2 - Baixe e carregue o sistema cacau com o github e asdf**

download do github:

```
git clone https://github.com/noloop/cacau.git
```

e carregue com o asdf:

```lisp
(asdf:load-system :cacau)
```

**Nota: Lembre-se de configurar o asdf para procurar o diretório onde você está guardando seus sistemas, para que o asdf consiga
carregá-los corretamente, você pode saber mais aqui:  https://common-lisp.net/project/asdf/asdf/Configuring-ASDF-to-find-your-systems.html ou https://lisp-lang.org/learn/writing-libraries.**_

## Começo rápido

```common-lisp

```


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

