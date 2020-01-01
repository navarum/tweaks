## Changes to [GNU R](https://www.r-project.org/)

See the [patches directory](patches/). Includes:

* Support for more than three mouse buttons (e.g. scroll wheel) in `getGraphicsEvent` (30 Dec 2019):

      > X11()
      > setGraphicsEventHandlers(onMouseUp=function(buttons,x,y) {print(buttons)})
      > while(1) {getGraphicsEvent()}
      Waiting for input
      [1] 3
      Waiting for input
      [1] 4
      Waiting for input
      [1] 0
      Waiting for input
      [1] 2
      Waiting for input
