import io.bit3.jsass.Compiler
import io.bit3.jsass.Options
import io.bit3.jsass.OutputStyle

tasks {
    register("compileScss") {
        val inputFile = file("src/scss/app.scss")
        val outputFile = file("build/app.css")

        inputs.dir(inputFile.parentFile)
        outputs.file(outputFile)

        doLast {
            val compiler = Compiler()
            val options = Options()
            options.outputStyle = OutputStyle.COMPRESSED

            val cssOutput = compiler.compileFile(inputFile.toURI(), outputFile.toURI(), options)

            outputFile.parentFile.mkdirs()
            outputFile.writeText(cssOutput.css)
        }
    }

    register<Exec>("compileElm") {
        val jsPath = "$projectDir/build/app.js"

        inputs.dir("$projectDir/src/elm")
        outputs.file(file(jsPath))

        workingDir = File("$projectDir/src/elm")
        commandLine = listOf("elm", "make", "--optimize", "--output", jsPath, "App.elm")
    }

    register<Delete>("clean") {
        delete.add("elm/elm-stuff/0.19.0")
        delete.add("elm/elm-stuff/generated-code")
        delete.add("build")
    }

    register<Copy>("build") {
        dependsOn("compileElm")
        dependsOn("compileScss")

        from("src/resources") {
            include("*.html")
        }
        into("build")

        doLast {
            File("build").mkdirs()
            File("build/Staticfile").createNewFile()
        }
    }
}
