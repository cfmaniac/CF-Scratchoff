/******************************************
 *
 * @author          J Harvey
 * This is the ScratchOff jQuery Plugin:
 * Version          2.0.3 (should be same as ScratchOff.cfc Build Number)
 ******************************************/
(function($)
{
	$.fn.wScratchPad = function(option, settings)
	{
		if(typeof option === 'object')
		{
			settings = option;
		}
		else if(typeof option == 'string')
		{
			var values = [];

			var elements = this.each(function()
			{
				var data = $(this).data('_wScratchPad');

				if(data)
				{
					if(option === 'reset') { data.reset(); }
					else if(option === 'clear') { data.clear(); }
					else if(option === 'enabled') { data.enabled = settings === true; }
					else if($.fn.wScratchPad.defaultSettings[option] !== undefined)
					{
						if(settings !== undefined) { data.settings[option] = settings; }
						else { values.push(data.settings[option]); }
					}
				}
			});

			if(values.length === 1) { return values[0]; }
			if(values.length > 0) { return values; }
			else { return elements; }
		}
		
		settings = $.extend({}, $.fn.wScratchPad.defaultSettings, settings || {});

		return this.each(function()
		{
			var elem = $(this);
			var $settings = jQuery.extend(true, {}, settings);

			//test for HTML5 canvas
			var test = document.createElement('canvas');
			if(!test.getContext)
			{
				elem.html("Browser does not support HTML5 canvas, please upgrade to a more modern browser.");
				return false;	
			}

			var sp = new ScratchPad($settings, elem);
			
			elem.append(sp.generate());
			
			//get number of pixels of canvas for percent calculations 
			sp.pixels = sp.canvas.width * sp.canvas.height;
			
			elem.data('_wScratchPad', sp);
			
			sp.init();
		});
	};

	$.fn.wScratchPad.defaultSettings =
	{
		width			: 210,					// set width - best to match image width
		height		: 100,					// set height - best to match image height
		image			: null,	                // set image path
		image2		: null,					// set overlay image path - if set color is not used
		textToDraw  : null,                 // set the Text to Drawn if Image is not defined.
		color			: '#336699',			// set scratch color - if image2 is not set uses color
		overlay		: 'none',				// set the type of overlay effect 'none', 'lighter' - only used with color
		size			: 10,					// set size of scratcher
		realtimePercent : false,              	// Update scratch percent only on the mouseup/touchend (for better performances on mobile device)
		scratchDown	: null,					// scratchDown callback
		scratchUp	: null,					// scratchUp callback
		scratchMove	: null,					// scratcMove callback
		cursor		: null					// Set path to custom cursor
	};
	
	function ScratchPad(settings, elem)
	{
		this.sp = null;
		this.settings = settings;
		this.$elem = elem;
		
		this.enabled = true;
		this.scratch = false;
		
		this.canvas = null;
		this.ctx = null;
		
		return this;
	}
	
	ScratchPad.prototype = 
	{
		generate: function()
		{
			var $this = this;
			
			this.canvas = document.createElement('canvas');
			this.ctx = this.canvas.getContext('2d');
			if(this.settings.textToDraw){
			
			}
			this.sp =
			$('<div></div>')
			.css({position: 'absolute'})
			.append(
				$(this.canvas)
				.attr('width', this.settings.width + 'px')
				.attr('height', this.settings.height + 'px')
			);
			/*$('<div></div>')
			.css({position: 'relative'})
			.append(
				$(this.canvas)
				.attr('width', this.settings.width + 'px')
				.attr('height', this.settings.height + 'px')
			);*/
			
			$(this.canvas)
			.mousedown(function(e)
			{
				if(!$this.enabled) return true;

				e.preventDefault();
				e.stopPropagation();
				
				//reset canvas offset in case it has moved
				$this.canvas_offset = $($this.canvas).offset();
				
				$this.scratch = true;
				$this.scratchFunc(e, $this, 'Down');
			})
			.mousemove(function(e)
			{
				e.preventDefault();
				e.stopPropagation();
				
				if($this.scratch) $this.scratchFunc(e, $this, 'Move');
			})
			.mouseup(function(e)
			{
				e.preventDefault();
				e.stopPropagation();
				
				//make sure we are in draw mode otherwise this will fire on any mouse up.
				if($this.scratch)
				{
					$this.scratch = false;
					$this.scratchFunc(e, $this, 'Up');
				}
			});

			this.bindMobile(this.sp);
			
			return this.sp;
		},
		
		bindMobile: function($el)
		{
			$el.bind('touchstart touchmove touchend touchcancel', function ()
			{
				var touches = event.changedTouches, first = touches[0], type = ""; 

				switch (event.type)
				{
					case "touchstart": type = "mousedown"; break; 
					case "touchmove": type = "mousemove"; break; 
					case "touchend": type = "mouseup"; break; 
					default: return;
				}

				var simulatedEvent = document.createEvent("MouseEvent"); 

				simulatedEvent.initMouseEvent(type, true, true, window, 1, first.screenX, first.screenY, first.clientX, first.clientY, false, false, false, false, 0/*left*/, null);
				first.target.dispatchEvent(simulatedEvent);
				event.preventDefault();
			});
		},

		init: function()
		{
			this.sp.css('width', this.settings.width);
			this.sp.css('height', this.settings.height);
			//this.sp.css('cursor', (this.settings.cursor ? 'url('+this.settings.cursor+'), pointer' : 'pointer'));

			$(this.canvas).css({cursor: (this.settings.cursor ? 'url(' + this.settings.cursor + '), pointer' : 'pointer')});
			
			this.canvas.width = this.settings.width;
			this.canvas.height = this.settings.height;
			
			this.pixels = this.canvas.width * this.canvas.height;
			
			if(this.settings.image2)
			{
				this.drawImage(this.settings.image2);
			} else if(this.settings.textToDraw)
			{
				this.drawText(this.settings.textToDraw);
			}
			
			
			else
			{
				if(this.settings.overlay != 'none')
				{
					if(this.settings.image)
					{
						this.drawImage(this.settings.image);
						//this.drawImage('This is Sample Text!')
					} else if (this.settings.textToDraw)
			        {
					    this.drawText(this.settings.textToDraw);
			        }
					this.ctx.globalCompositeOperation = this.settings.overlay;
					
				}
				else
				{
					this.setBgImage();
				}
				
				this.ctx.fillStyle = this.settings.color;
				this.ctx.beginPath();
				this.ctx.rect(0, 0, this.settings.width, this.settings.height)
				this.ctx.fill();
			}
		},

		reset: function()
		{
			this.ctx.globalCompositeOperation = 'source-over';
			this.init();
		},

		clear: function()
		{
			this.ctx.clearRect(0, 0, this.settings.width, this.settings.height);
		},

		setBgImage: function()
		{
			if(this.settings.image)
			{
				this.sp.css({backgroundImage: 'url('+this.settings.image+')'});
			}
		},
		
		//Modified to Use Text!
		drawText: function(textToWrite)
        {
            var $this = this;
            var grd=context.createLinearGradient(200,70,200,110); // sets the position of the gradient
                grd.addColorStop(0, "#f55b5b"); // sets the first color
                grd.addColorStop(1, "#3112a3"); // sets the second color

            $this.ctx.font= "70pt Georgia"; // sets the font and font size of the text
            $this.ctx.fillStyle=grd; // sets the text color
            $this.ctx.fillText(textToWrite, 50, 100, 230); // The text to be displayed and its position
           
        },


		drawImage: function(imagePath)
		{
			var $this = this;
			var img = new Image();
  			img.src = imagePath;
  			$(img).load(function(){
  				$this.ctx.drawImage(img, 0, 0);
  				$this.setBgImage();
  			})
		},
		
		
		scratchFunc: function(e, $this, event)
		{
			e.pageX = Math.floor(e.pageX - $this.canvas_offset.left);
			e.pageY = Math.floor(e.pageY - $this.canvas_offset.top);
			
			$this['scratch' + event](e, $this);
			
			if(this.settings.realtimePercent || event == "Up") {
				if($this.settings['scratch' + event]) $this.settings['scratch' + event].apply($this, [e, $this.scratchPercentage($this)]);
			}
		},

		scratchPercentage: function($this)
		{
			var hits = 0;
			var imageData = $this.ctx.getImageData(0,0,$this.canvas.width,$this.canvas.height)
			
			for(var i=0, ii=imageData.data.length; i<ii; i=i+4)
			{
				if(imageData.data[i] == 0 && imageData.data[i+1] == 0 && imageData.data[i+2] == 0 && imageData.data[i+3] == 0) hits++;
			}
			
			return (hits / $this.pixels) * 100;
		},

		scratchDown: function(e, $this)
		{
			$this.ctx.globalCompositeOperation = 'destination-out';
			$this.ctx.lineJoin = "round";
			$this.ctx.lineCap = "round";
			$this.ctx.strokeStyle = $this.settings.color;
			$this.ctx.lineWidth = $this.settings.size;
			
			//draw single dot in case of a click without a move
			$this.ctx.beginPath();
			$this.ctx.arc(e.pageX, e.pageY, $this.settings.size/2, 0, Math.PI*2, true);
			$this.ctx.closePath();
			$this.ctx.fill();
			
			//start the path for a drag
			$this.ctx.beginPath();
			$this.ctx.moveTo(e.pageX, e.pageY);
		},
		
		scratchMove: function(e, $this)
		{
			$this.ctx.lineTo(e.pageX, e.pageY);
			$this.ctx.stroke();
		},
		
		scratchUp: function(e, $this)
		{
			$this.ctx.closePath();
		},
	}
})(jQuery);

 /******************************************
 *
 * @author          J Harvey
 * This is the FireWorks Effect:
 ******************************************/
 if (!ScrecialWorks) var ScrecialWorks = {};
ScrecialWorks.fireworkShow = function (a, c) {
    function e() {
        a = j(a).eq(0);
        a.css("position") == "static" && a.css("position", "relative");
        h = j("<canvas class='ScratchBoxBG'></canvas>");
        if (!h[0].getContext) return false;
        h.attr({
            height: a.height(),
            width: a.width()
        }).css({
            position: "absolute",
            display: "block",
            top: 0,
            left: 0,
            zIndex: -1
        }).appendTo(a);
        n = ScrecialWorks.Canvas.scene(h[0]);
        l = setInterval(function () {
            Math.random() > 0.75 || ScrecialWorks.firework(n)
        }, 1.5 * c);
        k = true
    }
    var d = {}, j = jQuery,
        l, n, h, k = false;
    c = c || 900;
    e();
    d.remove = function () {
        if (k) {
            clearInterval(l);
            n.destroy();
            n = null;
            h.remove();
            a = h = null
        }
    };
    return d
};
ScrecialWorks || (ScrecialWorks = {});
ScrecialWorks.firework = function (a) {
    function c() {
        k = 360 * Math.random();
        f = ScrecialWorks.Color.hslToRgb([k, Math.random(), 0.2 + 0.8 * Math.random()]);
        i = (a.getCanvas().width - h * 2) * Math.random() + h;
        m = (a.getCanvas().height / 2 - h) * Math.random() + h;
        o = a.getCanvas().height;
        a.register(j)
    }
 
    function e() {
        if (o > m) {
            o -= 10;
            l.fillStyle = "rgb(" + f[0] + "," + f[1] + "," + f[2] + ")";
            l.beginPath();
            l.arc(Math.round(i), Math.round(o), 2, 0, 2 * Math.PI, true);
            l.fill()
        } else {
            a.remove(j);
            d()
        }
    }
 
    function d() {
        for (var p = 40 + Math.floor(50 * Math.random()); p--;) {
            var q = ScrecialWorks.Color.hslToRgb([k, Math.random(), 0.2 + 0.8 * Math.random()]);
            new n(a, q, i, m, 10)
        }
    }
    var j = {
        draw: e
    }, l = a.getContext(),
        n = ScrecialWorks.FireworkParticle,
        h = 70,
        k, i, m, o, f;
    c();
    return j
};
ScrecialWorks.FireworkParticle = function (a, c, e, d) {
    this.scene = a;
    this.color = c;
    this.x = Math.round(e);
    this.y = Math.round(d);
    this.rotate = 2 * Math.PI * Math.random();
    this.opacity = 500;
    this.f = 0;
    this.max = 50 + 10 * Math.random();
    this.size = 0;
    this.speed = 4 * Math.random();
    a.register(this)
};
ScrecialWorks.FireworkParticle.prototype = {
    getStyle: function () {
        return "rgba(" + this.color[0] + "," + this.color[1] + "," + this.color[2] + "," + this.opacity / 100 + ")"
    },
    draw: function (a, c) {
        if (this.f < this.max) {
            this.f++;
            this.size += this.speed;
            this.speed *= 0.95;
            if (this.f > 0.8 * this.max) this.opacity -= 6;
            c.lineWidth = 1;
            c.save();
            c.translate(this.x, this.y);
            c.rotate(this.rotate);
            c.strokeStyle = this.getStyle();
            c.beginPath();
            c.moveTo(Math.round(0.85 * this.size), 0);
            c.lineTo(Math.round(this.size), 0);
            c.stroke();
            c.restore()
        } else this.scene.remove(this)
    }
};
ScrecialWorks || (ScrecialWorks = {});
if (!ScrecialWorks.Canvas) ScrecialWorks.Canvas = {};
ScrecialWorks.Canvas.scene = function (a) {
    function c(f) {
        i.push(f)
    }
 
    function e() {
        for (var f = m.length; f--;) i[m[f]] = null;
        m = [];
        for (f = i.length; f--;) i[f] || i.splice(m[f], 1)
    }
 
    function d(f) {
        for (var p = i.length; p--;)
            if (f === i[p]) {
                m.push(p);
                break
            }
    }
 
    function j() {
        clearInterval(o)
    }
 
    function l() {
        return k
    }
 
    function n() {
        return a
    }
    var h = {
        register: c,
        remove: d,
        getContext: l,
        getCanvas: n,
        destroy: j
    }, k = a.getContext("2d"),
        i = [],
        m = [],
        o = setInterval(function () {
            k.clearRect(0, 0, a.width, a.height);
            for (var f = i.length; f--;) typeof i[f].draw == "function" && i[f].draw(h, k);
            e()
        }, 30);
    return h
};
ScrecialWorks || (ScrecialWorks = {});
if (!ScrecialWorks.Color) ScrecialWorks.Color = {};
ScrecialWorks.Color.hslToRgb = function (a) {
    var c = a[0],
        e = a[1];
    a = a[2];
    if (e == 0) r = g = b = a;
    e = a < 0.5 ? a * (1 + e) : a + e - a * e;
    a = 2 * a - e;
    c /= 360;
    var d = [];
    d[0] = c + 1 / 3;
    d[1] = c;
    d[2] = c - 1 / 3;
    for (c = 3; c--;) {
        d[c] %= 1;
        d[c] = d[c] < 1 / 6 ? a + (e - a) * 6 * d[c] : d[c] < 0.5 ? e : d[c] < 2 / 3 ? a + (e - a) * 6 * (2 / 3 - d[c]) : a;
        d[c] *= 255;
        d[c] = Math.floor(d[c]);
        if (d[c] < 0) d[c] = 0
    }
    return d
};
ScrecialWorks.Color.hslToRgb.test = function () {
    function a(e, d) {
        for (var j = e.lenght; j--;)
            if (e[j] !== d[j]) throw Error("Got " + e + ", expected " + d);
        console.log("success")
    }
    var c = ScrecialWorks.Color.hslToRgb;
    a(c([0, 1, 1]), [1, 0, 0]);
    a(c([120, 0.5, 1]), [0.5, 1, 0.5]);
    a(c([240, 1, 0.5]), [0, 0, 0.5]);
    c([104.15549071384422, 0.9040453462245244, 0.2855993456480115])
};