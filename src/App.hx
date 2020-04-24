package;

import js.Browser;
import js.html.Element;
import js.html.MouseEvent;
import coconut.ui.Renderer;
import coconut.ui.View;
import coconut.Ui.hxx;
import js.Browser.*;

class App extends View {
    static function main() {
        var target = document.getElementById('demo');
        Renderer.mount(target, <App />);
    }

    @:state var progress:Int = 33;
    
    function updateProgress(value) {
        this.progress = value;
    }

    function render() {
        return 
            <Progress progress={ progress } onchange={ updateProgress }/>
        ;
    }
}

class Progress extends View {
    
    @:attr var progress:Int = 0;
    @:attr var onchange:Int -> Void;
    
    @:ref var barElt:Element;

    var originX:Float;

    function startSeek(e:MouseEvent) {
        // I dont want this event to be heared
        // outside this component
        e.stopPropagation();

        // calculate progress in percents
        this.originX = e.pageX - e.offsetX;
        final width = this.barElt.getBoundingClientRect().width;
        final progress = (e.pageX - this.originX) * 100 / width;

        // lift progress value up 
        this.onchange(Math.round(progress));

        // enable control
        Browser.document.addEventListener('mouseup', this.stopSeek);
        Browser.document.addEventListener('mousemove', this.seek);
    }

    function stopSeek(e:MouseEvent) {
        Browser.document.removeEventListener('mouseup', this.stopSeek);
        Browser.document.removeEventListener('mousemove', this.seek);
    }

    function seek(e:MouseEvent) {
        // calculate current progress in percents
        final width = this.barElt.getBoundingClientRect().width;
        var progress = (e.pageX - this.originX) * 100 / width;
        
        // bound it in [0, 100]
        progress = Math.min(progress, 100);
        progress = Math.max(progress, 0);

        // lift progress value up 
        this.onchange(Math.round(progress));
    }

    function render(){
        final styles = {
            display: 'block',
            width: '300px',
            backgroundColor: '#654141',
            height: '20px',
            padding: '0',
            margin: '0',
            borderRadius: '5px'
        };

        return
        <div id="bg" ref={ this.barElt } style={ styles } onmousedown={ this.startSeek }>
            <bar progress={ this.progress }/>
        </div>
        ;
    }

    function bar(attr:{ progress: Int }) {
        final styles = {
            display: 'block',
            backgroundColor: '#f5187f',
            width: '${attr.progress}%',
            height: '100%',
            margin: '0',
            padding: '0',
            borderRadius: 'inherit'
        };

        return
            <div id="bar" style={ styles } ></div>
        ;
    }
}