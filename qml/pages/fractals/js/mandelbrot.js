.pragma library

function getColor(iter, maxIter, colorScheme) {
    if (iter === maxIter) return "black"

    var t = iter / maxIter

    switch(colorScheme) {
        case "Нет":
            var brightness = Math.floor(255 * t)
            return "rgb(" + brightness + ", " + brightness + ", " + brightness + ")"

        case "Огонь":
            var r = Math.min(255, Math.floor(255 * t * 2))
            var g = Math.floor(100 * t)
            var b = 0
            return "rgb(" + r + ", " + g + ", " + b + ")"

        case "Океан":
            var r = 0
            var g = Math.floor(100 * t)
            var b = Math.min(255, Math.floor(255 * t * 2))
            return "rgb(" + r + ", " + g + ", " + b + ")"

        default:
            return "black"
    }
}

function drawMandelbrot(canvas, width, height, maxIter, colorScheme,
                        centerX, centerY, zoom) {
    console.log("Начало")
    console.log("Размер:", width, height)
    console.log("maxIter:", maxIter)
    console.log("Центр:", centerX, centerY)
    console.log("Zoom:", zoom)

    var ctx = canvas.getContext('2d')
    ctx.clearRect(0, 0, width, height)

    var widthInPlane = 3.5 / zoom
    var heightInPlane = 2.0 / zoom

    var xMin = centerX - widthInPlane/2
    var xMax = centerX + widthInPlane/2
    var yMin = centerY - heightInPlane/2
    var yMax = centerY + heightInPlane/2

    for (var px = 0; px < width; px++) {
        for (var py = 0; py < height; py++) {
            var x0 = xMin + (px / width) * (xMax - xMin)
            var y0 = yMin + (py / height) * (yMax - yMin)

            var x = 0
            var y = 0
            var iter = 0

            while (x*x + y*y <= 4 && iter < maxIter) {
                var xtemp = x*x - y*y + x0
                y = 2*x*y + y0
                x = xtemp
                iter++
            }

            ctx.fillStyle = getColor(iter, maxIter, colorScheme)
            ctx.fillRect(px, py, 1, 1)
        }
    }

    console.log("Отрисовка завершена")
}
