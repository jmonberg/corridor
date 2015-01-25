/*  
	Animator.js 1.1.9
	
	This library is released under the BSD license:

	Copyright (c) 2006, Bernard Sumption. All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	Redistributions of source code must retain the above copyright notice, this
	list of conditions and the following disclaimer. Redistributions in binary
	form must reproduce the above copyright notice, this list of conditions and
	the following disclaimer in the documentation and/or other materials
	provided with the distribution. Neither the name BernieCode nor
	the names of its contributors may be used to endorse or promote products
	derived from this software without specific prior written permission. 
	
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
	OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
	DAMAGE.

*/


// Applies a sequence of numbers between 0 and 1 to a number of subjects
// construct - see setOptions for parameters
function Animator(options) {
	this.setOptions(options);
	var _this = this;
	this.timerDelegate = function(){_this.onTimerEvent()};
	this.subjects = [];
	this.target = 0;
	this.state = 0;
	this.lastTime = null;
};
Animator.prototype = {
	// apply defaults
	setOptions: function(options) {
		this.options = Animator.applyDefaults({
			interval: 20,  // time between animation frames
			duration: 400, // length of animation
			onComplete: function(){},
			onStep: function(){},
			transition: Animator.tx.easeInOut
		}, options);
	},
	// animate from the current state to provided value
	seekTo: function(to) {
		this.seekFromTo(this.state, to);
	},
	// animate from the current state to provided value
	seekFromTo: function(from, to) {
		this.target = Math.max(0, Math.min(1, to));
		this.state = Math.max(0, Math.min(1, from));
		this.lastTime = new Date().getTime();
		if (!this.intervalId) {
			this.intervalId = window.setInterval(this.timerDelegate, this.options.interval);
		}
	},
	// animate from the current state to provided value
	jumpTo: function(to) {
		this.target = this.state = Math.max(0, Math.min(1, to));
		this.propagate();
	},
	// seek to the opposite of the current target
	toggle: function() {
		this.seekTo(1 - this.target);
	},
	// add a function or an object with a method setState(state) that will be called with a number
	// between 0 and 1 on each frame of the animation
	addSubject: function(subject) {
		this.subjects[this.subjects.length] = subject;
		return this;
	},
	// remove all subjects
	clearSubjects: function() {
		this.subjects = [];
	},
	// forward the current state to the animation subjects
	propagate: function() {
		var value = this.options.transition(this.state);
		for (var i=0; i<this.subjects.length; i++) {
			if (this.subjects[i].setState) {
				this.subjects[i].setState(value);
			} else {
				this.subjects[i](value);
			}
		}
	},
	// called once per frame to update the current state
	onTimerEvent: function() {
		var now = new Date().getTime();
		var timePassed = now - this.lastTime;
		this.lastTime = now;
		var movement = (timePassed / this.options.duration) * (this.state < this.target ? 1 : -1);
		if (Math.abs(movement) >= Math.abs(this.state - this.target)) {
			this.state = this.target;
		} else {
			this.state += movement;
		}
		
		try {
			this.propagate();
		} finally {
			this.options.onStep.call(this);
			if (this.target == this.state) {
				window.clearInterval(this.intervalId);
				this.intervalId = null;
				this.options.onComplete.call(this);
			}
		}
	},
	// shortcuts
	play: function() {this.seekFromTo(0, 1)},
	reverse: function() {this.seekFromTo(1, 0)},
	// return a string describing this Animator, for debugging
	inspect: function() {
		var str = "#<Animator:\n";
		for (var i=0; i<this.subjects.length; i++) {
			str += this.subjects[i].inspect();
		}
		str += ">";
		return str;
	}
}
// merge the properties of two objects
Animator.applyDefaults = function(defaults, prefs) {
	prefs = prefs || {};
	var prop, result = {};
	for (prop in defaults) result[prop] = prefs[prop] !== undefined ? prefs[prop] : defaults[prop];
	return result;
}
// make an array from any object
Animator.makeArray = function(o) {
	if (o == null) return [];
	if (!o.length) return [o];
	var result = [];
	for (var i=0; i<o.length; i++) result[i] = o[i];
	return result;
}
// convert a dash-delimited-property to a camelCaseProperty (c/o Prototype, thanks Sam!)
Animator.camelize = function(string) {
	var oStringList = string.split('-');
	if (oStringList.length == 1) return oStringList[0];
	
	var camelizedString = string.indexOf('-') == 0
		? oStringList[0].charAt(0).toUpperCase() + oStringList[0].substring(1)
		: oStringList[0];
	
	for (var i = 1, len = oStringList.length; i < len; i++) {
		var s = oStringList[i];
		camelizedString += s.charAt(0).toUpperCase() + s.substring(1);
	}
	return camelizedString;
}
// syntactic sugar for creating CSSStyleSubjects
Animator.apply = function(el, style, options) {
	if (style instanceof Array) {
		return new Animator(options).addSubject(new CSSStyleSubject(el, style[0], style[1]));
	}
	return new Animator(options).addSubject(new CSSStyleSubject(el, style));
}
// make a transition function that gradually accelerates. pass a=1 for smooth
// gravitational acceleration, higher values for an exaggerated effect
Animator.makeEaseIn = function(a) {
	return function(state) {
		return Math.pow(state, a*2); 
	}
}
// as makeEaseIn but for deceleration
Animator.makeEaseOut = function(a) {
	return function(state) {
		return 1 - Math.pow(1 - state, a*2); 
	}
}
// make a transition function that, like an object with momentum being attracted to a point,
// goes past the target then returns
Animator.makeElastic = function(bounces) {
	return function(state) {
		state = Animator.tx.easeInOut(state);
		return ((1-Math.cos(state * Math.PI * bounces)) * (1 - state)) + state; 
	}
}
// make an Attack Decay Sustain Release envelope that starts and finishes on the same level
// 
Animator.makeADSR = function(attackEnd, decayEnd, sustainEnd, sustainLevel) {
	if (sustainLevel == null) sustainLevel = 0.5;
	return function(state) {
		if (state < attackEnd) {
			return state / attackEnd;
		}
		if (state < decayEnd) {
			return 1 - ((state - attackEnd) / (decayEnd - attackEnd) * (1 - sustainLevel));
		}
		if (state < sustainEnd) {
			return sustainLevel;
		}
		return sustainLevel * (1 - ((state - sustainEnd) / (1 - sustainEnd)));
	}
}
// make a transition function that, like a ball falling to floor, reaches the target and/
// bounces back again
Animator.makeBounce = function(bounces) {
	var fn = Animator.makeElastic(bounces);
	return function(state) {
		state = fn(state); 
		return state <= 1 ? state : 2-state;
	}
}
 
// pre-made transition functions to use with the 'transition' option
Animator.tx = {
	easeInOut: function(pos){
		return ((-Math.cos(pos*Math.PI)/2) + 0.5);
	},
	linear: function(x) {
		return x;
	},
	easeIn: Animator.makeEaseIn(1.5),
	easeOut: Animator.makeEaseOut(1.5),
	strongEaseIn: Animator.makeEaseIn(2.5),
	strongEaseOut: Animator.makeEaseOut(2.5),
	elastic: Animator.makeElastic(1),
	veryElastic: Animator.makeElastic(3),
	bouncy: Animator.makeBounce(1),
	veryBouncy: Animator.makeBounce(3)
}

// animates a pixel-based style property between two integer values
function NumericalStyleSubject(els, property, from, to, units) {
	this.els = Animator.makeArray(els);
	if (property == 'opacity' && window.ActiveXObject) {
		this.property = 'filter';
	} else {
		this.property = Animator.camelize(property);
	}
	this.from = parseFloat(from);
	this.to = parseFloat(to);
	this.units = units != null ? units : 'px';
}
NumericalStyleSubject.prototype = {
	setState: function(state) {
		var style = this.getStyle(state);
		var visibility = (this.property == 'opacity' && state == 0) ? 'hidden' : '';
		var j=0;
		for (var i=0; i<this.els.length; i++) {
			try {
				this.els[i].style[this.property] = style;
			} catch (e) {
				// ignore fontWeight - intermediate numerical values cause exeptions in firefox
				if (this.property != 'fontWeight') throw e;
			}
			if (j++ > 20) return;
		}
	},
	getStyle: function(state) {
		state = this.from + ((this.to - this.from) * state);
		if (this.property == 'filter') return "alpha(opacity=" + Math.round(state*100) + ")";
		if (this.property == 'opacity') return state;
		return Math.round(state) + this.units;
	},
	inspect: function() {
		return "\t" + this.property + "(" + this.from + this.units + " to " + this.to + this.units + ")\n";
	}
}

// animates a colour based style property between two hex values
function ColorStyleSubject(els, property, from, to) {
	this.els = Animator.makeArray(els);
	this.property = Animator.camelize(property);
	this.to = this.expandColor(to);
	this.from = this.expandColor(from);
	this.origFrom = from;
	this.origTo = to;
}

ColorStyleSubject.prototype = {
	// parse "#FFFF00" to [256, 256, 0]
	expandColor: function(color) {
		var hexColor, red, green, blue;
		hexColor = ColorStyleSubject.parseColor(color);
		if (hexColor) {
			red = parseInt(hexColor.slice(1, 3), 16);
			green = parseInt(hexColor.slice(3, 5), 16);
			blue = parseInt(hexColor.slice(5, 7), 16);
			return [red,green,blue]
		}
		if (window.DEBUG) {
			alert("Invalid colour: '" + color + "'");
		}
	},
	getValueForState: function(color, state) {
		return Math.round(this.from[color] + ((this.to[color] - this.from[color]) * state));
	},
	setState: function(state) {
		var color = '#'
				+ ColorStyleSubject.toColorPart(this.getValueForState(0, state))
				+ ColorStyleSubject.toColorPart(this.getValueForState(1, state))
				+ ColorStyleSubject.toColorPart(this.getValueForState(2, state));
		for (var i=0; i<this.els.length; i++) {
			this.els[i].style[this.property] = color;
		}
	},
	inspect: function() {
		return "\t" + this.property + "(" + this.origFrom + " to " + this.origTo + ")\n";
	}
}

// return a properly formatted 6-digit hex colour spec, or false
ColorStyleSubject.parseColor = function(string) {
	var color = '#', match;
	if(match = ColorStyleSubject.parseColor.rgbRe.exec(string)) {
		var part;
		for (var i=1; i<=3; i++) {
			part = Math.max(0, Math.min(255, parseInt(match[i])));
			color += ColorStyleSubject.toColorPart(part);
		}
		return color;
	}
	if (match = ColorStyleSubject.parseColor.hexRe.exec(string)) {
		if(match[1].length == 3) {
			for (var i=0; i<3; i++) {
				color += match[1].charAt(i) + match[1].charAt(i);
			}
			return color;
		}
		return '#' + match[1];
	}
	return false;
}
// convert a number to a 2 digit hex string
ColorStyleSubject.toColorPart = function(number) {
	if (number > 255) number = 255;
	var digits = number.toString(16);
	if (number < 16) return '0' + digits;
	return digits;
}
ColorStyleSubject.parseColor.rgbRe = /^rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i;
ColorStyleSubject.parseColor.hexRe = /^\#([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/;

// Animates discrete styles, i.e. ones that do not scale but have discrete values
// that can't be interpolated
function DiscreteStyleSubject(els, property, from, to, threshold) {
	this.els = Animator.makeArray(els);
	this.property = Animator.camelize(property);
	this.from = from;
	this.to = to;
	this.threshold = threshold || 0.5;
}

DiscreteStyleSubject.prototype = {
	setState: function(state) {
		var j=0;
		for (var i=0; i<this.els.length; i++) {
			this.els[i].style[this.property] = state <= this.threshold ? this.from : this.to; 
		}
	},
	inspect: function() {
		return "\t" + this.property + "(" + this.from + " to " + this.to + " @ " + this.threshold + ")\n";
	}
}

// animates between two styles defined using CSS.
// if style1 and style2 are present, animate between them, if only style1
// is present, animate between the element's current style and style1
function CSSStyleSubject(els, style1, style2) {
	els = Animator.makeArray(els);
	this.subjects = [];
	if (els.length == 0) return;
	var prop, toStyle, fromStyle;
	if (style2) {
		fromStyle = this.parseStyle(style1, els[0]);
		toStyle = this.parseStyle(style2, els[0]);
	} else {
		toStyle = this.parseStyle(style1, els[0]);
		fromStyle = {};
		for (prop in toStyle) {
			fromStyle[prop] = CSSStyleSubject.getStyle(els[0], prop);
		}
	}
	// remove unchanging properties
	var prop;
	for (prop in fromStyle) {
		if (fromStyle[prop] == toStyle[prop]) {
			delete fromStyle[prop];
			delete toStyle[prop];
		}
	}
	// discover the type (numerical or colour) of each style
	var prop, units, match, type, from, to;
	for (prop in fromStyle) {
		var fromProp = String(fromStyle[prop]);
		var toProp = String(toStyle[prop]);
		if (toStyle[prop] == null) {
			if (window.DEBUG) alert("No to style provided for '" + prop + '"');
			continue;
		}
		
		if (from = ColorStyleSubject.parseColor(fromProp)) {
			to = ColorStyleSubject.parseColor(toProp);
			type = ColorStyleSubject;
		} else if (fromProp.match(CSSStyleSubject.numericalRe)
				&& toProp.match(CSSStyleSubject.numericalRe)) {
			from = parseFloat(fromProp);
			to = parseFloat(toProp);
			type = NumericalStyleSubject;
			match = CSSStyleSubject.numericalRe.exec(fromProp);
			var reResult = CSSStyleSubject.numericalRe.exec(toProp);
			if (match[1] != null) {
				units = match[1];
			} else if (reResult[1] != null) {
				units = reResult[1];
			} else {
				units = reResult;
			}
		} else if (fromProp.match(CSSStyleSubject.discreteRe)
				&& toProp.match(CSSStyleSubject.discreteRe)) {
			from = fromProp;
			to = toProp;
			type = DiscreteStyleSubject;
			units = 0;   // hack - how to get an animator option down to here
		} else {
			if (window.DEBUG) {
				alert("Unrecognised format for value of "
					+ prop + ": '" + fromStyle[prop] + "'");
			}
			continue;
		}
		this.subjects[this.subjects.length] = new type(els, prop, from, to, units);
	}
}

CSSStyleSubject.prototype = {
	// parses "width: 400px; color: #FFBB2E" to {width: "400px", color: "#FFBB2E"}
	parseStyle: function(style, el) {
		var rtn = {};
		// if style is a rule set
		if (style.indexOf(":") != -1) {
			var styles = style.split(";");
			for (var i=0; i<styles.length; i++) {
				var parts = CSSStyleSubject.ruleRe.exec(styles[i]);
				if (parts) {
					rtn[parts[1]] = parts[2];
				}
			}
		}
		// else assume style is a class name
		else {
			var prop, value, oldClass;
			oldClass = el.className;
			el.className = style;
			for (var i=0; i<CSSStyleSubject.cssProperties.length; i++) {
				prop = CSSStyleSubject.cssProperties[i];
				value = CSSStyleSubject.getStyle(el, prop);
				if (value != null) {
					rtn[prop] = value;
				}
			}
			el.className = oldClass;
		}
		return rtn;
		
	},
	setState: function(state) {
		for (var i=0; i<this.subjects.length; i++) {
			this.subjects[i].setState(state);
		}
	},
	inspect: function() {
		var str = "";
		for (var i=0; i<this.subjects.length; i++) {
			str += this.subjects[i].inspect();
		}
		return str;
	}
}
// get the current value of a css property, 
CSSStyleSubject.getStyle = function(el, property){
	var style;
	if(document.defaultView && document.defaultView.getComputedStyle){
		style = document.defaultView.getComputedStyle(el, "").getPropertyValue(property);
		if (style) {
			return style;
		}
	}
	property = Animator.camelize(property);
	if(el.currentStyle){
		style = el.currentStyle[property];
	}
	return style || el.style[property]
}


CSSStyleSubject.ruleRe = /^\s*([a-zA-Z\-]+)\s*:\s*(\S(.+\S)?)\s*$/;
CSSStyleSubject.numericalRe = /^-?\d+(?:\.\d+)?(%|[a-zA-Z]{2})?$/;
CSSStyleSubject.discreteRe = /^\w+$/;

// required because the style object of elements isn't enumerable in Safari
/*
CSSStyleSubject.cssProperties = ['background-color','border','border-color','border-spacing',
'border-style','border-top','border-right','border-bottom','border-left','border-top-color',
'border-right-color','border-bottom-color','border-left-color','border-top-width','border-right-width',
'border-bottom-width','border-left-width','border-width','bottom','color','font-size','font-size-adjust',
'font-stretch','font-style','height','left','letter-spacing','line-height','margin','margin-top',
'margin-right','margin-bottom','margin-left','marker-offset','max-height','max-width','min-height',
'min-width','orphans','outline','outline-color','outline-style','outline-width','overflow','padding',
'padding-top','padding-right','padding-bottom','padding-left','quotes','right','size','text-indent',
'top','width','word-spacing','z-index','opacity','outline-offset'];*/


CSSStyleSubject.cssProperties = ['azimuth','background','background-attachment','background-color','background-image','background-position','background-repeat','border-collapse','border-color','border-spacing','border-style','border-top','border-top-color','border-right-color','border-bottom-color','border-left-color','border-top-style','border-right-style','border-bottom-style','border-left-style','border-top-width','border-right-width','border-bottom-width','border-left-width','border-width','bottom','clear','clip','color','content','cursor','direction','display','elevation','empty-cells','css-float','font','font-family','font-size','font-size-adjust','font-stretch','font-style','font-variant','font-weight','height','left','letter-spacing','line-height','list-style','list-style-image','list-style-position','list-style-type','margin','margin-top','margin-right','margin-bottom','margin-left','max-height','max-width','min-height','min-width','orphans','outline','outline-color','outline-style','outline-width','overflow','padding','padding-top','padding-right','padding-bottom','padding-left','pause','position','right','size','table-layout','text-align','text-decoration','text-indent','text-shadow','text-transform','top','vertical-align','visibility','white-space','width','word-spacing','z-index','opacity','outline-offset','overflow-x','overflow-y'];


// chains several Animator objects together
function AnimatorChain(animators, options) {
	this.animators = animators;
	this.setOptions(options);
	for (var i=0; i<this.animators.length; i++) {
		this.listenTo(this.animators[i]);
	}
	this.forwards = false;
	this.current = 0;
}

AnimatorChain.prototype = {
	// apply defaults
	setOptions: function(options) {
		this.options = Animator.applyDefaults({
			// by default, each call to AnimatorChain.play() calls jumpTo(0) of each animator
			// before playing, which can cause flickering if you have multiple animators all
			// targeting the same element. Set this to false to avoid this.
			resetOnPlay: true
		}, options);
	},
	// play each animator in turn
	play: function() {
		this.forwards = true;
		this.current = -1;
		if (this.options.resetOnPlay) {
			for (var i=0; i<this.animators.length; i++) {
				this.animators[i].jumpTo(0);
			}
		}
		this.advance();
	},
	// play all animators backwards
	reverse: function() {
		this.forwards = false;
		this.current = this.animators.length;
		if (this.options.resetOnPlay) {
			for (var i=0; i<this.animators.length; i++) {
				this.animators[i].jumpTo(1);
			}
		}
		this.advance();
	},
	// if we have just play()'d, then call reverse(), and vice versa
	toggle: function() {
		if (this.forwards) {
			this.seekTo(0);
		} else {
			this.seekTo(1);
		}
	},
	// internal: install an event listener on an animator's onComplete option
	// to trigger the next animator
	listenTo: function(animator) {
		var oldOnComplete = animator.options.onComplete;
		var _this = this;
		animator.options.onComplete = function() {
			if (oldOnComplete) oldOnComplete.call(animator);
			_this.advance();
		}
	},
	// play the next animator
	advance: function() {
		if (this.forwards) {
			if (this.animators[this.current + 1] == null) return;
			this.current++;
			this.animators[this.current].play();
		} else {
			if (this.animators[this.current - 1] == null) return;
			this.current--;
			this.animators[this.current].reverse();
		}
	},
	// this function is provided for drop-in compatibility with Animator objects,
	// but only accepts 0 and 1 as target values
	seekTo: function(target) {
		if (target <= 0) {
			this.forwards = false;
			this.animators[this.current].seekTo(0);
		} else {
			this.forwards = true;
			this.animators[this.current].seekTo(1);
		}
	}
}

// an Accordion is a class that creates and controls a number of Animators. An array of elements is passed in,
// and for each element an Animator and a activator button is created. When an Animator's activator button is
// clicked, the Animator and all before it seek to 0, and all Animators after it seek to 1. This can be used to
// create the classic Accordion effect, hence the name.
// see setOptions for arguments
function Accordion(options) {
	this.setOptions(options);
	var selected = this.options.initialSection, current;
	if (this.options.rememberance) {
		current = document.location.hash.substring(1);
	}
	this.rememberanceTexts = [];
	this.ans = [];
	var _this = this;
	for (var i=0; i<this.options.sections.length; i++) {
		var el = this.options.sections[i];
		var an = new Animator(this.options.animatorOptions);
		var from = this.options.from + (this.options.shift * i);
		var to = this.options.to + (this.options.shift * i);
		an.addSubject(new NumericalStyleSubject(el, this.options.property, from, to, this.options.units));
		an.jumpTo(0);
		var activator = this.options.getActivator(el);
		activator.index = i;
		activator.onclick = function(){_this.show(this.index)};
		this.ans[this.ans.length] = an;
		this.rememberanceTexts[i] = activator.innerHTML.replace(/\s/g, "");
		if (this.rememberanceTexts[i] === current) {
			selected = i;
		}
	}
	this.show(selected);
}

Accordion.prototype = {
	// apply defaults
	setOptions: function(options) {
		this.options = Object.extend({
			// REQUIRED: an array of elements to use as the accordion sections
			sections: null,
			// a function that locates an activator button element given a section element.
			// by default it takes a button id from the section's "activator" attibute
			getActivator: function(el) {return document.getElementById(el.getAttribute("activator"))},
			// shifts each animator's range, for example with options {from:0,to:100,shift:20}
			// the animators' ranges will be 0-100, 20-120, 40-140 etc.
			shift: 0,
			// the first page to show
			initialSection: 0,
			// if set to true, document.location.hash will be used to preserve the open section across page reloads 
			rememberance: true,
			// constructor arguments to the Animator objects
			animatorOptions: {}
		}, options || {});
	},
	show: function(section) {
		for (var i=0; i<this.ans.length; i++) {
			this.ans[i].seekTo(i > section ? 1 : 0);
		}
		if (this.options.rememberance) {
			document.location.hash = this.rememberanceTexts[section];
		}
	}
}


/******************************************************************************
Name:    Basic Functions
Version: 0.9 (March 26 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Basic Functions is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

/******************************************************************************
  get the screensize
******************************************************************************/

function getScreenSize() {
	var x = y = 0;
	if (self.innerHeight) {
		// all except Explorer
		x = self.innerWidth;
		y = self.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) {
		// Explorer 6 Strict Mode
		x = document.documentElement.clientWidth;
		y = document.documentElement.clientHeight;
	} else if (document.body) {
		// other Explorers
		x = document.body.clientWidth;
		y = document.body.clientHeight;
	}

	return [x,y];
}

/******************************************************************************
  get the total site dimensions
******************************************************************************/

function getSiteDimensions() {
	
	var x = y = 0;
	var screensize = getScreenSize();
	
	if (window.innerHeight && window.scrollMaxY) {
		x = window.innerWidth + window.scrollMaxX;
		y = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight) {
		// all but Explorer Mac
		x = document.body.scrollWidth;
		y = document.body.scrollHeight;
	} else if (document.documentElement && document.documentElement.scrollHeight > document.documentElement.offsetHeight) {
		// Explorer 6 strict mode
		x = document.documentElement.scrollWidth;
		y = document.documentElement.scrollHeight;
	} else {
		// Explorer Mac...would also work in Mozilla and Safari
		x = document.body.offsetWidth;
		y = document.body.offsetHeight;
	}
	
	// for small pages with total height less then height of the viewport
	if(y < screensize[1]) {
		y = screensize[1];
	}

	// for small pages with total width less then width of the viewport
	if(x < screensize[0]) {
		x = screensize[0];
	}

	return [x,y];
}

/******************************************************************************
  find the position of an element (http://www.quirksmode.org/js/findpos.html)
******************************************************************************/

function findPos(obj) {
	var curleft = curtop = 0;
	if (obj.offsetParent) {
		curleft = obj.offsetLeft
		curtop = obj.offsetTop
		while (obj = obj.offsetParent) {
			curleft += obj.offsetLeft
			curtop += obj.offsetTop
		}
	}
	return [curleft,curtop];
}

/******************************************************************************
  disable selection of site elements
******************************************************************************/

function disableSelection(){
	if(window.getSelection){
		if(navigator.userAgent.indexOf('AppleWebKit/') > -1){
			if(window.devicePixelRatio) {
				window.getSelection().removeAllRanges();
			} else {
				window.getSelection().collapse();
			}
		}else{
			window.getSelection().removeAllRanges();
		}
	}else if(document.selection){
		if(document.selection.empty){
			document.selection.empty();
		}else if(document.selection.clear){
			document.selection.clear();
		}
	}

	var element = document.body;
	if(navigator.userAgent.indexOf('Gecko') > -1 && navigator.userAgent.indexOf('KHTML') == -1){
		element.style.MozUserSelect = "none";
	}else if(navigator.userAgent.indexOf('AppleWebKit/') > -1){
		element.style.KhtmlUserSelect = "none"; 
	}else if(!!(window.attachEvent && !window.opera)){
		element.unselectable = "on";
		element.onselectstart = function() {
		        return false;
		};
	}
}

/******************************************************************************
  enable selection of site elements
******************************************************************************/

function enableSelection(){
	var element = document.body;
	if(navigator.userAgent.indexOf('Gecko') > -1 && navigator.userAgent.indexOf('KHTML') == -1){ 
		element.style.MozUserSelect = "";
	}else if(navigator.userAgent.indexOf('AppleWebKit/') > -1){
		element.style.KhtmlUserSelect = "";
	}else if(!!(window.attachEvent && !window.opera)){
		element.unselectable = "off";
		element.onselectstart = function() {
		        return true;
		};
	}else{
		return false;
	}
	return true;
}

/******************************************************************************
  clear nodes
******************************************************************************/

function clearContent(id) {
    var content = $(id);
    while(content.hasChildNodes()){
        content.removeChild(content.childNodes[0]);
    }    
}

// --- END

/******************************************************************************
Name:    processXML
Version: 1.0 (December 20 2007)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
processXML is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

processXML = Class.create();

processXML.prototype = {

	initialize: function(options) {
		
		// vars
		var xml = this;
		var req;
		
		this.isIE = false;
		this.tags = new Array();
		this.tmpTags = '';
		this.result = new Array();
		
		this.options = options || {};
		this.initialized = true;

	},
	
	load: function(url) {
	    // native XMLHttpRequest object
	    if (window.XMLHttpRequest) {
	        req = new XMLHttpRequest();
	        req.onreadystatechange = this.process;
	        req.open("GET", url, true);
	        req.send(null);
	    // IE on Windows ActiveX version
	    } else if (window.ActiveXObject) {
	        this.isIE = true;
	        req = new ActiveXObject("Microsoft.XMLHTTP");
	        if (req) {
	            req.onreadystatechange = this.process;
	            req.open("GET", url, true);
	            req.send();
	        }
	    }
	},
	
	findTagNames: function(node) {
		if (node.tagName) {
			if (this.tmpTags.search(node.tagName) == -1) {	
				if (this.tmpTags == '') {
					this.tmpTags = node.tagName;
				} else {
					this.tmpTags = this.tmpTags + ' ' + node.tagName;
				}
			}
		}
		if (node.hasChildNodes()) {
			for (var i=0, j=node.childNodes.length; i<j; i+=1) {
				if (node.childNodes[i].tagName) {
					if (this.tmpTags.search(node.childNodes[i].tagName) == -1) {
						this.tmpTags = this.tmpTags + ' ' + node.childNodes[i].tagName;
					}
				}
				if (node.childNodes[i].hasChildNodes()) {
					this.findTagNames(node.childNodes[i]);
				}
			}
		}
	},
	
	process: function() {
	    // only if req shows "loaded"
	    if (req.readyState == 4) {
	        // only if "OK"
	        if (req.status == 200) {
				var type = req.responseXML.getElementsByTagName("type");
				var content = req.responseXML;
				if (content.hasChildNodes()) {
					myXML.tmpTags = '';
					for (var i=0, j=content.childNodes.length; i<j; i+=1) {
						myXML.findTagNames(content.childNodes[i]);
					}
					myXML.buildContent();
			    }
	         } else {
	            alert("There was a problem retrieving the XML data:\n" + req.statusText);
	         }
	    }
	},
	
	buildContent: function() {
		
		// all available content tags will be collected in this.result['tags']
		
		// vars
		var whiteSpace = new RegExp(/[\f\n\r\t\u00A0\u2028\u2029]/g);
		var resultTags = new Array();
		
		// tags
		this.tags = this.tmpTags.split(' ');
		
		// collect content
		for (var i=0, j=this.tags.length; i<j; i+=1) {		
			var items = req.responseXML.getElementsByTagName(this.tags[i]);
			var itemsArray = new Array();
			for (var x=0, y=items.length; x<y; x+=1) {
				if ((items[x].firstChild.nodeType == 3) && (!whiteSpace.test(items[x].firstChild.nodeValue))) {
					itemsArray.push(items[x].firstChild.nodeValue);
				}
			}
			if (itemsArray.length > 0) {
				resultTags.push(this.tags[i]);
				this.result[this.tags[i]] = itemsArray;
			}
		}
		this.result['tags'] = resultTags;
		
		if (this.initialized && this.options.onBuild) {
			this.options.onBuild(this.result);
		}

	}
	
}

// --- END

/******************************************************************************
Name:    Resize Control
Version: 1.0 (March 19 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Resize Control is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

// --- globals

var floorSize = 				0.25;
var ceilingSize = 				1.00;
var startSize =					0.25;

// --- class

Resize = Class.create();

Resize.prototype = {

	initialize: function(wrapper, options) {
		
		var resizer = this;
		
		// options
		this.options = options || {};
		this.listItem = this.options.listItem;
		this.images = this.options.images;
		this.reflections = this.options.reflections;
		this.titles = this.options.titles;
		this.startValues = this.options.startValues;
		
		this.wrapper = wrapper;
		
		// call this functions on slider change
		mySlider.options.onSlide = function(value) {
			myResize.draw(value);
		}
		
		this.initialized = true;
		
		this.draw(startSize);
		
	},
	
	draw: function(value) {
		
		// set start size
		startSize = value;
		
		// ratio
		this.ratio = floorSize + (value * (ceilingSize - floorSize));
		
		// area width
		this.thumbsAreaWidth = parseInt(Element.getStyle(this.wrapper, 'width'));
		
		// calculate new list item size
		this.newThumbsItemWidth = Math.round(this.ratio * thumbsMaxWidth);
		this.newThumbsItemHeight = Math.round(this.ratio * totalMaxHeight);
		
		if (reflection === true) {
			this.newThumbsItemHeight = this.newThumbsItemHeight + Math.round(this.ratio * reflectionHeight) + reflectionTopMargin;
		}
		
		// calculate new item margins
		this.itemsInLine = Math.floor(this.thumbsAreaWidth / (this.newThumbsItemWidth + thumbsMinMargin));
		if (this.itemsInLine > this.images.length) {
			this.itemsInLine = this.images.length;
		}
		this.itemsInLineWidth = this.itemsInLine * (this.newThumbsItemWidth + thumbsMinMargin);
		this.newThumbsItemMargin = Math.floor((this.thumbsAreaWidth - this.itemsInLineWidth) / (this.itemsInLine * 2)) + (thumbsMinMargin / 2);
		
		// calculate and set new thumbs area height
		this.linesInArea = Math.ceil(this.images.length / this.itemsInLine);
		this.newThumbsAreaHeight = Math.ceil(this.linesInArea * (this.newThumbsItemHeight + thumbsMarginTop));
		$(this.wrapper).style.height = this.newThumbsAreaHeight + 'px';

		// resize content
		for (var i=0, j=this.images.length; i<j; i+=1) {
		
			// calculate new image size
			this.newImageWidth = Math.floor(this.ratio * this.startValues[i][0]);
			this.newImageHeight = Math.floor(this.ratio * this.startValues[i][1]);
			
			// calculate new reflection size
			if (reflection === true) {
				this.newReflectionWidth = this.newImageWidth;
				this.newReflectionHeight = Math.floor(this.ratio * reflectionHeight);
			}
			
			// calculate new left margin
			this.newMarginLeft = Math.floor((this.newThumbsItemWidth - this.newImageWidth) / 2);
			
			// scale the images
			this.images[i].style.width = this.newImageWidth + 'px';
		    this.images[i].style.height = this.newImageHeight + 'px';
			this.images[i].style.marginLeft = this.newMarginLeft + 'px';
		
			// scale the reflection
			if (reflection === true) {
				this.reflections[i].style.width = this.newReflectionWidth + 'px';
		    	this.reflections[i].style.height = this.newReflectionHeight + 'px';
				this.reflections[i].style.marginTop = reflectionTopMargin + 'px';
				this.reflections[i].style.marginLeft = this.newMarginLeft + 'px';
			}
			
			// scale the title
			if (this.newThumbsItemWidth >= 150) {
				this.titles[i].style.marginTop = '-' + this.newReflectionHeight + 'px';
				this.titles[i].style.marginLeft = this.newMarginLeft + 'px';
				this.titles[i].style.width = this.newReflectionWidth + 'px';
				this.titles[i].style.display = 'block';
				if (this.newThumbsItemWidth >= 250) {
					this.titles[i].style.fontSize = '12px';
				} else if (this.newThumbsItemWidth >= 200) {
					this.titles[i].style.fontSize = '11px';
				} else {
					this.titles[i].style.fontSize = '10px';
				}
			} else {
				this.titles[i].style.display = 'none';
			}
			
			// scale the items
			this.listItem[i].style.width = this.newThumbsItemWidth + 'px';
		    this.listItem[i].style.height = this.newThumbsItemHeight + 'px';
		
			// set the new items margin
			this.listItem[i].style.marginLeft = this.newThumbsItemMargin + 'px';
			this.listItem[i].style.marginRight = this.newThumbsItemMargin + 'px';
			this.listItem[i].style.marginTop = thumbsMarginTop + 'px';
			
			// arrange the item to the frame bottom
			if (reflection === true) {
				this.images[i].style.marginTop = this.newThumbsItemHeight - this.newImageHeight - this.newReflectionHeight - reflectionTopMargin + 'px';
			} else {
				this.images[i].style.marginTop = this.newThumbsItemHeight - this.newImageHeight + 'px';
			}
			
			// resize scroller
			myScroller.resizeHandle();
			
		}
		
	}
	
}

// --- END

/******************************************************************************
Name:    Scroller Control
Version: 0.9 (March 27 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Scroller Control is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

// --- globals

var setting_scroller_arrow =			'both'; 		// top, bottom, both
var setting_track_position = 			'right'; 		// right, left
var setting_offset_top =				-7;				// the top handle offset (depends on the used graphics)
var setting_offset_bottom =				-7;				// the bottom handle offset (depends on the used graphics)
var setting_default_mousewhell_off = 	false;			// turns the default mousewhell actions for the whole page off
var setting_mousewhell_trigger = 		'container';	// document, container (container turns the default mousewhell actions off if the cursor is inside the container)

// --- nomenclature

var id_scroller_container =				'scroller_container';
var id_scroller_track = 				'scroller_track';
var id_scroller_up =					'scroller_up';
var id_scroller_down = 					'scroller_down';
var id_scroller_handle = 				'scroller_handle';
var id_scroller_handle_top =			'scroller_handle_top';
var id_scroller_handle_middle = 		'scroller_handle_middle';
var id_scroller_handle_bottom =			'scroller_handle_bottom';

// --- class

contentScroller = Class.create();

contentScroller.prototype = {
	
	initialize: function(container, content, options) {
		var scroller = this;
		
		// options
		this.options = options || {};
		
		this.arrowPosition = this.options.arrowPosition;
		this.trackPosition = this.options.trackPosition;
		this.offsetTop = this.options.offsetTop;
		this.offsetBottom = this.options.offsetBottom;
		this.contentLeftMargin = this.options.contentLeftMargin;
		this.contentRightMargin = this.options.contentRightMargin;
		
		// set content
		this.content = $(content);
		
		// create scroller
		if(!$(id_scroller_track)) {
			var objContainer = document.getElementById(container);
			
			var objTrack = new Element('div', { 'id': id_scroller_track });
			objContainer.appendChild(objTrack);
			
			var objArrowUp = new Element('div', { 'id': id_scroller_up });
			objTrack.appendChild(objArrowUp);
			
			var objArrowDown = new Element('div', { 'id': id_scroller_down });
			objTrack.appendChild(objArrowDown);
			
			var objHandle = new Element('div', { 'id': id_scroller_handle });
			objTrack.appendChild(objHandle);
			
			var objHandleTop = new Element('div', { 'id': id_scroller_handle_top });
			objHandle.appendChild(objHandleTop);
			
			var objHandleMiddle = new Element('div', { 'id': id_scroller_handle_middle });
			objHandle.appendChild(objHandleMiddle);
			
			var objHandleBottom = new Element('div', { 'id': id_scroller_handle_bottom });
			objHandle.appendChild(objHandleBottom);
			
			// set styles
			this.containerWidth = parseInt(Element.getStyle(objContainer, 'width'));
			this.trackHeight = parseInt(Element.getStyle(objContainer, 'height'));
			this.trackWidth = parseInt(Element.getStyle(objTrack, 'width'));
			this.handleCapTopHeight = parseInt(Element.getStyle(objHandleTop, 'height'));
			this.handleCapBottomHeight = parseInt(Element.getStyle(objHandleBottom, 'height'));
			this.handleHeight = this.handleCapTopHeight + this.handleCapBottomHeight;
			this.arrowUpHeight = parseInt(Element.getStyle(objArrowUp, 'height'));
			this.arrowDownHeight = parseInt(Element.getStyle(objArrowDown, 'height'));
			
			objTrack.setStyle({
				height: this.trackHeight + 'px',
				top: '0px'
			});
			
			if (this.trackPosition == 'left') {
				objTrack.setStyle({
					left: '0px'
				});
			} else if (this.trackPosition == 'right') {
				objTrack.setStyle({
					left: this.containerWidth - this.trackWidth + 'px'
				});
			}
			
			if (this.arrowPosition == 'top') {
				objHandle.setStyle({
					marginTop: this.arrowUpHeight + this.arrowDownHeight + this.offsetTop + 'px'
				});
				objArrowUp.setStyle({
					marginTop: '0px'
				});
				objArrowDown.setStyle({
					marginTop: this.arrowUpHeight + 'px'
				});
			} else if (this.arrowPosition == 'both') {
				objHandle.setStyle({
					marginTop: this.arrowUpHeight + this.offsetTop + 'px'
				});
				objArrowUp.setStyle({
					marginTop: '0px'
				});
				objArrowDown.setStyle({
					marginTop: this.trackHeight - this.arrowDownHeight + 'px'
				});
			} else if (this.arrowPosition == 'bottom') {
				objHandle.setStyle({
					marginTop: this.offsetTop + 'px'
				});
				objArrowUp.setStyle({
					marginTop: this.trackHeight - this.arrowUpHeight - this.arrowDownHeight + 'px'
				});
				objArrowDown.setStyle({
					marginTop: this.trackHeight - this.arrowDownHeight + 'px'
				});
			}
			
			// set elements
			this.handle = objHandle;
			this.handleMiddle = objHandleMiddle;
			this.track = objTrack;
			this.up = objArrowUp;
			this.down = objArrowDown;
			
			// set event listner
			this.eventMouseDownHandle = this.startDrag.bindAsEventListener(this);
			this.eventMouseDownTrack = this.setHandle.bindAsEventListener(this);
			this.eventMouseUp   = this.endDrag.bindAsEventListener(this);
			this.eventMouseMove = this.moveHandle.bindAsEventListener(this);
			this.eventMouseDownArrowUp = this.startScroll.bindAsEventListener(this, 'up');
			this.eventMouseDownArrowDown = this.startScroll.bindAsEventListener(this, 'down');
			this.eventMouseUpArrow = this.endScroll.bindAsEventListener(this);
			this.eventMouseWheel = this.wheel.bindAsEventListener(this);

			Event.observe(this.handle, 'mousedown', this.eventMouseDownHandle);
			Event.observe(this.track, 'mousedown', this.eventMouseDownTrack);
			Event.observe(this.up, 'mousedown', this.eventMouseDownArrowUp);
			Event.observe(this.down, 'mousedown', this.eventMouseDownArrowDown);
			if (setting_mousewhell_trigger == 'container') {
				Event.observe(objContainer, 'mousewheel', this.eventMouseWheel);
				Event.observe(objContainer, "DOMMouseScroll", this.eventMouseWheel); // Firefox
			} else {
				Event.observe(document, 'mousewheel', this.eventMouseWheel);
				Event.observe(document, "DOMMouseScroll", this.eventMouseWheel); // Firefox
			}
			
		}
		
		// resize
		this.resizeHandle();
		
		this.active = false;
		this.scroll = false;
		this.initialized = true;
	},
	
	startDrag: function(e) {
		this.position = parseInt(this.handle.style.marginTop) || 0;
		this.startY = e.clientY - this.position;
		Event.observe(document, 'mousemove', this.eventMouseMove);
		Event.observe(document, 'mouseup', this.eventMouseUp);
		this.active = true;
		disableSelection();
	},
	
	endDrag: function(e) {
		if (this.active === true) {
			Event.stopObserving(document, 'mousedown', this.eventMouseMove);
			Event.stopObserving(document, 'mouseup', this.eventMouseUp);
			this.active = false;
			enableSelection();
		}
	},
	
	startScroll: function(e, direction) {
		this.scroll = true;
		Event.observe(document, 'mouseup', this.eventMouseUpArrow);
		this.moveArrow(direction);
	},
	
	endScroll: function(e) {
		this.scroll = false;
		Event.stopObserving(document, 'mouseup', this.eventMouseUpArrow);
	},
	
	wheel: function(event) {
		var delta = 0;
		if (!event) event = window.event;

		if (event.wheelDelta) {
			// IE / Opera
			delta = event.wheelDelta / 120;
			if (window.opera) {
				delta = -delta;
			}
		} else if (event.detail) {
			// Mozilla
			//delta = -event.detail/3;
			delta = -event.detail; // scroll faster
		}
		
		if (delta) {
			this.marginTop = (this.marginTop-=delta) || 0;
			this.draw('wheel');
		}
		
		// prevent default actions
		if ((setting_default_mousewhell_off === true) || (setting_mousewhell_trigger == 'container')) {
			if (event.preventDefault) {
				event.preventDefault();
			}
			event.returnValue = false;
		}
	},
	
	setHandle: function(e) {
		var element, offset;
		
		if (e.target) {
			element = e.target;
		} else if (e.srcElement) {
			element = e.srcElement;
		}
		
		// defeat Safari bug
		if (element.nodeType == 3) {
			element = element.parentNode;
		}
		
		if (element.id == this.track.getAttribute('id')) {
			if(e.layerY){
				this.marginTop = parseInt(e.layerY) - (this.handleHeight/2);
			} else if (e.offsetY) {
				this.marginTop = parseInt(e.offsetY) - (this.handleHeight/2);
			}
			
			this.draw('track');
		}
	},
	
	moveHandle: function(e) {
		if (this.active === true) {

			this.posY = e.clientY;
			this.marginTop = this.posY - this.startY;
			
			this.draw('handle');
		}
	},
	
	moveArrow: function(direction) {
		if (this.scroll === true) {
			
			var scrollStep = Math.round(this.scrollFactor);
			if (scrollStep < 1) {
				scrollStep = 1;
			}
			
			if (direction == 'up') {
				this.marginTop = (this.marginTop-=scrollStep) || 0;
			} else if (direction == 'down') {
				this.marginTop = (this.marginTop+=scrollStep) || 0;
			}
			this.draw('arrow');
			setTimeout('myScroller.moveArrow("'+direction+'")', 0);
		}
	},
	
	draw: function(element) {
		if (this.arrowPosition == 'top') {
			if (this.marginTop < (this.arrowUpHeight + this.arrowDownHeight + this.offsetTop)) {
				this.marginTop = this.arrowUpHeight + this.arrowDownHeight + this.offsetTop;
			}
			if (this.marginTop > (this.trackHeight - this.handleHeight - this.offsetBottom)) {
				this.marginTop = (this.trackHeight - this.handleHeight - this.offsetBottom);
			}
			this.options.scrollerValue = (this.marginTop - this.arrowUpHeight - this.arrowDownHeight - this.offsetTop) / (this.trackHeight - this.handleHeight - this.arrowUpHeight - this.arrowDownHeight - this.offsetTop - this.offsetBottom);
		} else if (this.arrowPosition == 'both') {
			if (this.marginTop < (this.arrowUpHeight + this.offsetTop)) {
				this.marginTop = this.arrowUpHeight + this.offsetTop;
			}
			if (this.marginTop > (this.trackHeight - this.handleHeight - this.arrowDownHeight - this.offsetBottom)) {
				this.marginTop = (this.trackHeight - this.handleHeight - this.arrowDownHeight - this.offsetBottom);
			}
			this.options.scrollerValue = (this.marginTop - this.arrowUpHeight - this.offsetTop) / (this.trackHeight - this.handleHeight - this.arrowUpHeight - this.arrowDownHeight - this.offsetTop - this.offsetBottom);
		} else if (this.arrowPosition == 'bottom') {
			if (this.marginTop < this.offsetTop) {
				this.marginTop = this.offsetTop;
			}
			if (this.marginTop > (this.trackHeight - this.handleHeight - this.arrowUpHeight - this.arrowDownHeight - this.offsetBottom)) {
				this.marginTop = (this.trackHeight - this.handleHeight - this.arrowUpHeight - this.arrowDownHeight - this.offsetBottom);
			}
			this.options.scrollerValue = (this.marginTop - this.offsetTop) / (this.trackHeight - this.handleHeight - this.arrowUpHeight - this.arrowDownHeight - this.offsetTop - this.offsetBottom);
		}
		
		// movement
		if(element == 'track') {
			window.scroller_move = new Animator({
				duration: 500
			}).addSubject(new CSSStyleSubject(
				this.handle, 'margin-top: '+this.marginTop+'px')
			).addSubject(new CSSStyleSubject(
				this.content, 'margin-top: -'+((this.marginTop - (this.arrowUpHeight + this.offsetTop)) * this.scrollFactor)+'px')
			);
		
			window.scroller_move.seekTo(1);
		} else {
			this.handle.style.marginTop = this.marginTop + 'px';
			this.content.style.marginTop = '-' + ((this.marginTop - (this.arrowUpHeight + this.offsetTop)) * this.scrollFactor) + 'px';
		}
		
		if (this.initialized && this.options.onScroll) {
			this.options.onScroll(this.options.scrollerValue);
		}
	},
	
	resizeHandle: function() {
		
		// reset top margins
		// TODO: resize without setting the margins back
		this.content.style.marginTop = '0px';
		
		if (this.arrowPosition == 'top') {
			this.handle.setStyle({
				marginTop: this.arrowUpHeight + this.arrowDownHeight + this.offsetTop + 'px'
			});
		} else if (this.arrowPosition == 'both') {
			this.handle.setStyle({
				marginTop: this.arrowUpHeight + this.offsetTop + 'px'
			});
		} else if (this.arrowPosition == 'bottom') {
			this.handle.setStyle({
				marginTop: this.offsetTop + 'px'
			});
		}
		
		
		// content horizontal position and track visibility
		this.contentHeight = parseInt(Element.getStyle(this.content, 'height'));
		if (this.contentHeight > this.trackHeight) {
			if (this.trackPosition == 'left') {
				this.content.setStyle({
					position: 'absolute',
					left: this.trackWidth + this.contentLeftMargin + 'px',
					width: this.containerWidth - this.trackWidth - this.contentLeftMargin - this.contentRightMargin + 'px'
				});
			} else if (this.trackPosition == 'right') {
				this.content.setStyle({
					position: 'absolute',
					left: this.contentLeftMargin + 'px',
					width: this.containerWidth - this.trackWidth - this.contentLeftMargin - this.contentRightMargin + 'px'
				});
			}
		} else {
			this.content.setStyle({
				position: 'absolute',
				left: this.contentLeftMargin + 'px',
				width: this.containerWidth - this.contentLeftMargin - this.contentRightMargin + 'px'
			});
		}
		
		// content height
		this.contentHeight = parseInt(Element.getStyle(this.content, 'height'));
		
		// handle height
		this.handleHeight = (this.trackHeight * (this.trackHeight - (this.arrowUpHeight + this.offsetTop) - (this.arrowDownHeight + this.offsetBottom))) / this.contentHeight;
		$(id_scroller_handle_middle).setStyle({
			height: (this.handleHeight - this.handleCapTopHeight - this.handleCapBottomHeight) + 'px'
		});
		
		// track visibilty
		if ((this.contentHeight > this.trackHeight) && (Element.getStyle(id_scroller_track, 'display') == 'none')) {
			this.track.setStyle({
				display: 'block'
			});
			
			// fix for thumbnail view on resize
			if ((Element.getStyle(id_thumbs, 'display') == 'block') && (Element.getStyle(id_overview, 'display') == 'none')) {
				this.resizeHandle();
				myResize.draw(startSize);
			}
		} else if (this.contentHeight <= this.trackHeight) {
			this.track.setStyle({
				display: 'none'
			});
		}
		
		// track scrolling space
		this.trackSpace = this.trackHeight - this.handleHeight - (this.arrowUpHeight + this.offsetTop) - (this.arrowDownHeight + this.offsetBottom);
		
		// content hidden height
		this.contentScroll = this.contentHeight - this.trackHeight;
		
		// scroll factor
		this.scrollFactor = this.contentScroll / this.trackSpace;
		
	},
	
	setContent: function(contentId) {
		// reset top margins
		this.content.setStyle({
			marginTop: '0px'
		});
		
		if (this.arrowPosition == 'top') {
			this.handle.setStyle({
				marginTop: this.arrowUpHeight + this.arrowDownHeight + this.offsetTop + 'px'
			});
		} else if (this.arrowPosition == 'both') {
			this.handle.setStyle({
				marginTop: this.arrowUpHeight + this.offsetTop + 'px'
			});
		} else if (this.arrowPosition == 'bottom') {
			this.handle.setStyle({
				marginTop: this.offsetTop + 'px'
			});
		}
		
		// new content
		this.content = $(contentId);
		this.content.setStyle({
			marginTop: '0px'
		});
		
		// set handle
		this.resizeHandle();
	}
	
}

// --- END

/******************************************************************************
Name:    Skimmer Control
Version: 1.0 (March 17 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Skimmer Control is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

// --- globals

var skimmerMaxWidth =			160;
var skimmerMaxHeight =			160;

// --- nomenclature

var class_Skimmer = 			'skimmer';
var class_SkimmerWrapper = 		'skimmerFrame';
var class_SkimmerMask = 		'skimmerMask';
var class_SkimmerTitle = 		'skimmerTitle';
var class_SkimmerCounter = 		'skimmerCounter';
var class_SkimmerMarker = 		'skimmerMarker';

// --- class

if(!Control) var Control = {};
Control.Skimmer = Class.create();

Control.Skimmer.prototype = {

	initialize: function(options) {
		
		var skimmer = this;
		
		// options
		this.options = options || {};
		this.marker = this.options.marker;
		this.indicator = this.options.indicator;
		this.size = this.options.size;
		
		// vars
		this.counter = 0;
		
		// collect the skimmers
		this.anchors = $$('div.'+this.marker);
		this.skimmerCounter = this.anchors.length;
			
		for (var i=0, j=this.anchors.length; i<j; i+=1) {
				
			// create listner
			Event.observe(this.anchors[i], 'mousemove', this.move.bindAsEventListener(this));
			Event.observe(this.anchors[i], 'mouseout', this.reset.bindAsEventListener(this));
			
			// create indicator
			if (this.indicator === true) {
				var skimmerMarker = new Element('div', { 'class': class_SkimmerMarker });
				this.anchors[i].appendChild(skimmerMarker);
			}

		}
		
	},
	
	move: function(e) {
		e = e||window.event;
		
		var activeSkimmer = $(Event.element(e)).up('.'+class_Skimmer);
		if (!activeSkimmer) {
			var activeSkimmer = Event.element(e);
		}
		
		// reset all other skimmers - fix for bubbling bug
		for (var i=0; i<this.skimmerCounter; i+=1) {
			var tmpSkimmerId = class_Skimmer + '_' + i;
			if ((activeSkimmer.id != tmpSkimmerId) && ($(tmpSkimmerId).lastChild.getStyle('display') != 'none')) {
				
				$(tmpSkimmerId).setStyle({
					backgroundPosition: '0px 0px'
				});
				
				$(tmpSkimmerId).lastChild.setStyle({
					display: 'none'
				});

				this.counter = 0;
			}
		}
		
		// get skimmer size
		if (this.counter == 0) {
			var imgSrc = activeSkimmer.getStyle('backgroundImage').split('url(');
			imgSrc = imgSrc[1].split(')');
			imgSrc = imgSrc[0];
		
			var image = new Image();
			image.src = imgSrc;
		
			this.counter = image.height / this.size;
		}
		
		// calc new position
		var mouseX = Event.pointerX(e)
		var offset = findPos(activeSkimmer);
		var imgPosition = Math.round((mouseX - offset[0]) / (this.size / (this.counter - 1)));
		
		// set indicator
		if (this.indicator === true) {
			activeSkimmer.lastChild.setStyle({
			  display: 'block'
			});
		}
		
		// move items
		this.moveImage(activeSkimmer, imgPosition);
	},
	
	moveImage: function(activeSkimmer, imgPosition) {
		
		// move indicator
		if (this.indicator === true) {
			if(imgPosition != (this.counter - 1)) {
				activeSkimmer.lastChild.setStyle({
				  width: Math.floor(this.size / this.counter) + 'px'
				});
			} else {
				activeSkimmer.lastChild.setStyle({
				  width: Math.floor(this.size / this.counter) + (this.size % Math.floor(this.size / this.counter)) + 'px'
				});
			}
			activeSkimmer.lastChild.setStyle({
			  left: (this.size / this.counter) * imgPosition + 'px'
			});
		}
	
		// move image
		activeSkimmer.setStyle({
		  backgroundPosition: '0px ' + (-this.size * imgPosition) + 'px'
		});
		
	},
	
	reset: function(e) {
		e = e||window.event;
		var eventTarget = e.relatedTarget || e.toElement;

		if ((eventTarget.getAttribute('class') != class_SkimmerMarker) && (eventTarget.getAttribute('class') != class_SkimmerMask)) {
			var activeSkimmer = $(Event.element(e)).up('.'+class_Skimmer);
			if (!activeSkimmer) {
				var activeSkimmer = Event.element(e);
			}
			this.moveImage(activeSkimmer, 0);
			this.counter = 0;
			if (this.indicator === true) {
				activeSkimmer.lastChild.setStyle({
				  display: 'none'
				});
			}
		}
	}
	
}

// --- END

/******************************************************************************
Name:    Slider Control
Version: 1.0 (March 18 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Slider Control is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

// --- nomenclature

var id_slider =					'slider';
var id_sliderTrack =			'slider_track';
var id_sliderHandle =			'slider_handle';
var id_sliderLeftIcon =			'slider_left_icon';
var id_sliderRightIcon =		'slider_right_icon';

// --- class

if(!Control) var Control = {};
Control.Slider = Class.create();

Control.Slider.prototype = {
	
	initialize: function(target, options) {
		
		var slider = this;
		
		// options
		this.options = options || {};
		
		this.id_slider = this.options.slider;
		this.id_sliderTrack = this.options.sliderTrack;
		this.id_sliderHandle = this.options.sliderHandle;
		this.id_sliderLeftIcon = this.options.sliderLeftIcon;
		this.id_sliderRightIcon = this.options.sliderRightIcon;
		
		this.target = $(target);
		
		// create DOM nodes
		if(!$(this.id_slider)) {
			
			var objSlider = new Element('div', { id: this.id_slider });
			this.target.appendChild(objSlider);
			
			var objSliderLeftIcon = new Element('div', { id: this.id_sliderLeftIcon });
			objSlider.appendChild(objSliderLeftIcon);
			
			var objSliderTrack = new Element('div', { id: this.id_sliderTrack });
			objSlider.appendChild(objSliderTrack);
			
			var objSliderHandle = new Element('div', { id: this.id_sliderHandle });
			objSliderTrack.appendChild(objSliderHandle);
			
			var objSliderRightIcon = new Element('div', { id: this.id_sliderRightIcon });
			objSlider.appendChild(objSliderRightIcon);
			
		}
		
		this.sliderWidth = parseInt(Element.getStyle(this.id_sliderTrack, 'width'));
		this.handleWidth = parseInt(Element.getStyle(this.id_sliderHandle, 'width'));
		this.iconsWidth = parseInt(Element.getStyle(this.id_sliderLeftIcon, 'width'));
		
		this.track = $(this.id_sliderTrack);
		this.handle = $(this.id_sliderHandle);
		
		// events
		this.eventMouseDownHandle = this.startDrag.bindAsEventListener(this);
		this.eventMouseDownTrack = this.setSlider.bindAsEventListener(this);
		this.eventMouseUp   = this.endDrag.bindAsEventListener(this);
		this.eventMouseMove = this.moveSlider.bindAsEventListener(this);
			
		Event.observe(this.handle, 'mousedown', this.eventMouseDownHandle);
		Event.observe(this.track, 'mousedown', this.eventMouseDownTrack);
		
		this.active = false;
		this.initialized = true;
		
		this.draw(this.options.sliderValue);
	},
	
	startDrag: function(e) {
		this.position = parseInt(this.handle.style.marginLeft) || 0;
		this.startX = e.clientX - this.position;
		Event.observe(document, 'mousemove', this.eventMouseMove);
		Event.observe(document, 'mouseup', this.eventMouseUp);
		this.active = true;
	},
	
	endDrag: function(e) {
		if (this.active === true) {
			Event.stopObserving(document, 'mousedown', this.eventMouseMove);
			Event.stopObserving(document, 'mouseup', this.eventMouseUp);
			this.active = false;
		}
	},
	
	setSlider: function(e) {
		var element, offset;
		
		if (e.target) {
			element = e.target;
		} else if (e.srcElement) {
			element = e.srcElement;
		}
		
		// defeat Safari bug
		if (element.nodeType == 3) {
			element = element.parentNode;
		}
		
		if (element.id == this.id_sliderTrack) {
			if(e.layerX){
				offset = parseInt(e.layerX) - this.iconsWidth - (this.handleWidth/2);
			} else if (e.offsetX) {
				offset = parseInt(e.offsetX) - (this.handleWidth/2);
			}
			
			if (offset < 0) {
				offset = 0;
			}
			
			if (offset > (this.sliderWidth-this.handleWidth)) {
				offset = (this.sliderWidth-this.handleWidth);
			}
			
			this.options.sliderValue = offset / (this.sliderWidth-this.handleWidth);
			
			this.draw();
		}
	},
	
	moveSlider: function(e) {
		if (this.active === true) {
			disableSelection();

			this.posX = e.clientX;
			this.marginLeft = this.posX - this.startX;
			
			if (this.marginLeft < 0) {
				this.marginLeft = 0;
			}
			
			if (this.marginLeft > (this.sliderWidth-this.handleWidth)) {
				this.marginLeft = (this.sliderWidth-this.handleWidth);
			}
			
			this.options.sliderValue = this.marginLeft / (this.sliderWidth-this.handleWidth);
			
			this.draw();
		}
	},
	
	draw: function() {
		
		this.handle.setStyle({
			marginLeft: this.options.sliderValue * (this.sliderWidth-this.handleWidth) + 'px'
		});
		
		if (this.initialized && this.options.onSlide) {
			this.options.onSlide(this.options.sliderValue);
		}
	}
	
}

// --- END

/******************************************************************************
Name:    Image Viewer
Version: 0.9 (March 30 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Image Viewer is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

// --- globals

var lightbox_marker =				'lightbox';
var lightbox_close = 				'left';
var lightbox_listner =				true;
var lightbox_space = 				100;
var lightbox_border = 				10;
var lightbox_title_lineheight = 	30;
var lightbox_title_opacity = 		0.8;
var lightbox_overlay_opacity = 		0.8;
var lightbox_processing_opacity = 	0.6;

// --- nomenclature

var id_viewer = 					'imgViewer';
var id_viewer_overlay =				'imgViewer_overlay';
var id_viewer_loading =				'imgViewer_loading';
var id_viewer_processing =			'imgViewer_processing';
var id_viewer_container =			'imgViewer_container';
var id_viewer_image =				'imgViewer_image';
var id_viewer_title =				'imgViewer_title';
var id_viewer_closebox =			'imgViewer_closebox';
var id_viewer_navi_left =			'imgViewer_naviLeft';
var id_viewer_navi_right =			'imgViewer_naviRight';

// --- initialize
//------------------------------------------------------------------------------------------------------------------------
// function initViewer() { 
// 	myViewer = new imgViewer({
// 		marker: 'lightbox',
// 		close: 'left',
// 		listner: true
// 	});
// }
// 
// Event.observe(window, 'load', initViewer, false);
//------------------------------------------------------------------------------------------------------------------------

// --- class

imgViewer = Class.create();

imgViewer.prototype = {

	initialize: function(options) {
		
		var viewer = this;
		
		// options
		this.options = options || {};
		this.marker = this.options.marker;
		this.closePosition = this.options.close;
		this.listner = this.options.listner;
		
		// vars
		this.position = 0;
		this.firstRun = true;
		
		// add event listner
		if (this.listner === true) {
			this.anchors = $$('a.'+this.marker);
		
			for (var i=0, j=this.anchors.length; i<j; i+=1) {
				Event.observe(this.anchors[i], 'click', this.load.bindAsEventListener(this));
			}
		} else {
			this.anchors = $$('a.'+this.marker);
		}
		
		// create DOM nodes
		if(!$(id_viewer_overlay)) {
			var objBody = $$('body')[0];
			
			var objOverlay = new Element('div', { id: id_viewer_overlay }).setStyle({
				display: 'none'
			});
			objBody.appendChild(objOverlay);
			
			var objLoading = new Element('div', { id: id_viewer_loading });
			objOverlay.appendChild(objLoading);
			
			var objViewer = new Element('div', { id: id_viewer }).setStyle({
				display: 'none'
			});
			objBody.appendChild(objViewer);
			
			var objProcessing = new Element('div', { id: id_viewer_processing }).setStyle({
				display: 'none'
			});
			objBody.appendChild(objProcessing);

			// build animations
			this.basicAnimations();
		}

	},
	
	load: function(e) {
		
		// event
		if (!e.type) {
			var element = e;
		} else {
			e = e||window.event;
			var element = $(Event.element(e)).up('.'+this.marker);
			if (!element) {
				var element = Event.element(e);
			}
		}
		
		if (this.firstRun === true) {
			
			// lightbox space
			this.lightbox_fullSpace = ((lightbox_space + lightbox_border) * 2);
		
			// get dimensions
			this.viewport = document.viewport.getDimensions();
			this.siteDimensions = getSiteDimensions();
			this.scrollOffset = document.viewport.getScrollOffsets();
		
			// set overlay
			$(id_viewer_overlay).setStyle({ width: this.siteDimensions[0] + 'px' });
			$(id_viewer_overlay).setStyle({ height: this.siteDimensions[1] + 'px' });
			
			// set loading animation
			var id_viewer_loading_width = parseInt($(id_viewer_loading).getStyle('width'));
			var id_viewer_loading_height = parseInt($(id_viewer_loading).getStyle('height'));
			
			$(id_viewer_loading).setStyle({ marginLeft: Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) - (id_viewer_loading_width / 2)) + 'px' });
			$(id_viewer_loading).setStyle({ marginTop: Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - (id_viewer_loading_height / 2)) + 'px' });
			
			// set processing animation
			var id_viewer_processing_width = parseInt($(id_viewer_processing).getStyle('width'));
			var id_viewer_processing_height = parseInt($(id_viewer_processing).getStyle('height'));
			
			$(id_viewer_processing).setStyle({ marginLeft: Math.floor( this.scrollOffset['left'] + (this.viewport['width'] / 2) - (id_viewer_processing_width / 2)) + 'px' });
			$(id_viewer_processing).setStyle({ marginTop: Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - (id_viewer_processing_height / 2)) + 'px' });
		
			// show overlay
			window.imgViewer_aniOverlay.seekTo(lightbox_overlay_opacity);
		
			// build image
			if (element.href) {
				this.src = element.href;
			} else {
				this.src = element;
			}
		
			this.image = new Image();
			this.image.src = this.src;
		
		}
		
		// build DOM
		if (this.image.complete === true) {
			
			// get image position
			this.srcSource = this.src.split('/');
			this.srcSource = this.srcSource[this.srcSource.length-1];
			this.srcSource = this.srcSource.replace(/\?/g, '_');
			
			for (var i=0, j=this.anchors.length; i<j; i+=1) {
				
				this.srcCheck = this.anchors[i].readAttribute('href').split('/');
				this.srcCheck = this.srcCheck[this.srcCheck.length-1];
				this.srcCheck = this.srcCheck.replace(/\?/g, '_');
				
				if (this.srcSource.match(this.srcCheck)) {
					this.position = i;
					if (this.anchors[i].readAttribute('title') != null) {
						this.imgTitle = this.anchors[i].readAttribute('title');
					} else {
						this.imgTitle = this.anchors[i].readAttribute('alt');
					}
				}
			}

			// check if image is larger then screen
			if ((this.image.width + this.lightbox_fullSpace) > this.viewport['width']) {
				this.imgWidth = this.viewport['width'] - this.lightbox_fullSpace;
				this.imgHeight = (this.image.height * this.imgWidth) / this.image.width;
			} else {
				this.imgWidth = this.image.width;
				this.imgHeight = this.image.height;
			}

			if ((this.imgHeight + this.lightbox_fullSpace) > this.viewport['height']) {
				this.imgWidth = (this.imgWidth * (this.viewport['height'] - this.lightbox_fullSpace)) / this.imgHeight;
				this.imgHeight = this.viewport['height'] - this.lightbox_fullSpace;
			}
			
			// build
			var objImgFrame = new Element('div', { id: id_viewer_container }).setStyle({
				position: 'absolute',
				width: this.imgWidth + (lightbox_border * 2) + 'px',
				height: this.imgHeight + (lightbox_border * 2) + 'px',
				marginLeft: Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) - ((this.imgWidth + (lightbox_border * 2)) / 2)) + 'px',
				marginTop: Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - ((this.imgHeight + (lightbox_border * 2)) / 2)) + 'px'
			});
			$(id_viewer).appendChild(objImgFrame);
			
			var objImg = new Element('img', { id: id_viewer_image, src: this.image.src }).setStyle({
				width: this.imgWidth + 'px',
				height: this.imgHeight + 'px',
				marginLeft: lightbox_border + 'px',
				marginTop: lightbox_border + 'px'
			});
			objImgFrame.appendChild(objImg);
			
			var objTitle = new Element('div', { id: id_viewer_title }).setStyle({
				position: 'absolute',
				display: 'block',
				width: (this.imgWidth - lightbox_border) + 'px',
				height: '0px',
				top: (this.imgHeight + lightbox_border) + 'px',
				left: '0px',
				marginLeft: lightbox_border + 'px',
				marginTop: '0px',
				paddingLeft: (lightbox_border / 2) + 'px',
				paddingRight: (lightbox_border / 2) + 'px',
				lineHeight: lightbox_title_lineheight + 'px',
				opacity: lightbox_title_opacity,
				overflow: 'hidden'
			}).update(this.imgTitle);
			objImgFrame.appendChild(objTitle);
			
			var objClosebox = new Element('div', { id: id_viewer_closebox });
			$(id_viewer).appendChild(objClosebox);
			
			if (this.closePosition == 'left') {
				$(id_viewer_closebox).setStyle({
					marginLeft: Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) - ((this.imgWidth + (lightbox_border * 2)) / 2) - (parseInt($(id_viewer_closebox).getStyle('width')) / 2)) + 'px',
					marginTop: Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - ((this.imgHeight + (lightbox_border * 2)) / 2) - (parseInt($(id_viewer_closebox).getStyle('height')) / 2)) + 'px'
				});
			} else {
				$(id_viewer_closebox).setStyle({
					marginLeft: Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) + ((this.imgWidth + (lightbox_border * 2)) / 2) - (parseInt($(id_viewer_closebox).getStyle('width')) / 2)) + 'px',
					marginTop: Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - ((this.imgHeight + (lightbox_border * 2)) / 2) - (parseInt($(id_viewer_closebox).getStyle('height')) / 2)) + 'px'
				});
			}
			
			var objNaviLeft = new Element('div', { id: id_viewer_navi_left });
			$(id_viewer).appendChild(objNaviLeft);
			
			var id_viewer_navi_left_width = parseInt($(id_viewer_navi_left).getStyle('width'));
			var id_viewer_navi_left_height = parseInt($(id_viewer_navi_left).getStyle('height'));
			$(id_viewer_navi_left).setStyle({
				marginLeft: Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2)) - id_viewer_navi_left_width + 'px',
				marginTop: Math.floor(this.scrollOffset['top'] + this.viewport['height'] - (this.lightbox_fullSpace / 2) + (((this.lightbox_fullSpace / 2) - id_viewer_navi_left_height) / 2)) + 'px'
			});
			
			var objNaviRight = new Element('div', { id: id_viewer_navi_right });
			$(id_viewer).appendChild(objNaviRight);
			
			var id_viewer_navi_right_width = parseInt($(id_viewer_navi_right).getStyle('width'));
			var id_viewer_navi_right_height = parseInt($(id_viewer_navi_right).getStyle('height'));
			$(id_viewer_navi_right).setStyle({
				marginLeft: Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2)) + 'px',
				marginTop: Math.floor(this.scrollOffset['top'] + this.viewport['height'] - (this.lightbox_fullSpace / 2) + (((this.lightbox_fullSpace / 2) - id_viewer_navi_right_height) / 2)) + 'px'
			});
			
			// event listner
			Event.observe(objImg, 'mouseover', new Function('fx_Img_TitleIn', 'window.imgViewer_aniTitle.seekTo(1)'));
			Event.observe(objImg, 'mouseout', new Function('fx_Img_TitleOut', 'window.imgViewer_aniTitle.seekTo(0)'));
			Event.observe(objTitle, 'mouseover', new Function('fx_Title_TitleIn', 'window.imgViewer_aniTitle.seekTo(1)'));
			Event.observe(objTitle, 'mouseout', new Function('fx_Title_TitleOut', 'window.imgViewer_aniTitle.seekTo(0)'));
			Event.observe(objClosebox, 'click', new Function('fx_closeBox', 'myViewer.hide()'));
			Event.observe(objNaviLeft, 'click', new Function('fx_naviLeft', 'myViewer.prev()'));
			Event.observe(objNaviRight, 'click', new Function('fx_naviRight', 'myViewer.next()'));

			// build animations
			this.imgAnimations();
			
			// set firstRun back
			this.firstRun = true;

			// display the first image
			this.show();
		} else {
			this.firstRun = false;
			setTimeout("myViewer.load('"+element+"')",50);
		}
		
	},
	
	next: function() {
		
		// vars
		var positionNext, src, image, imgWidth, imgHeight, imgTitle;
		
		// show img loading
		window.imgViewer_aniProcessing.seekTo(lightbox_processing_opacity);
		
		// next image
		positionNext = this.position + 1;
		if (positionNext >= this.anchors.length) {
			positionNext = 0;
		}
		
		// image title
		if (this.anchors[positionNext].getAttribute('title') != null) {
			this.imgTitle = this.anchors[positionNext].getAttribute('title');
		} else {
			this.imgTitle = this.anchors[positionNext].getAttribute('alt');
		}

		// build image
		src = this.anchors[positionNext].getAttribute('href');
		image = new Image();
		image.src = src;

		if (image.complete === true) {
			
			window.imgViewer_aniImage.seekTo(0);
			window.imgViewer_aniTitle.seekTo(0);

			// check if image is larger then screen
			if ((image.width + this.lightbox_fullSpace) > this.viewport['width']) {
				imgWidth = this.viewport['width'] - this.lightbox_fullSpace;
				imgHeight = (image.height * imgWidth) / image.width;
			} else {
				imgWidth = image.width;
				imgHeight = image.height;
			}

			if ((imgHeight + this.lightbox_fullSpace) > this.viewport['height']) {
				imgWidth = (imgWidth * (this.viewport['height'] - this.lightbox_fullSpace)) / imgHeight;
				imgHeight = this.viewport['height'] - this.lightbox_fullSpace;
			}

			// set title
			$(id_viewer_title).setStyle({
				top: (imgHeight + lightbox_border) + 'px',
				width: (imgWidth - lightbox_border) + 'px'
			}).update(this.imgTitle);;
			
			// hide img loading
			window.imgViewer_aniProcessing.seekTo(0);

			// resize box
			this.resize(image.src, imgWidth, imgHeight);

			// set position
			this.position = positionNext;
		} else {
			setTimeout("myViewer.next()",50);
		}
		
	},
	
	prev: function() {
		
		// vars
		var positionPrev, src, image, imgWidth, imgHeight, imgTitle;
		
		// show img loading
		window.imgViewer_aniProcessing.seekTo(lightbox_overlay_opacity);
		
		// next image
		positionPrev = this.position - 1;
		if (positionPrev < 0) {
			positionPrev = this.anchors.length - 1;
		}
		
		// image title
		if (this.anchors[positionPrev].getAttribute('title') != null) {
			this.imgTitle = this.anchors[positionPrev].getAttribute('title');
		} else {
			this.imgTitle = this.anchors[positionPrev].getAttribute('alt');
		}

		// build image
		src = this.anchors[positionPrev].getAttribute('href');
		image = new Image();
		image.src = src;

		if (image.complete === true) {
			window.imgViewer_aniImage.seekTo(0);
			window.imgViewer_aniTitle.seekTo(0)

			// check if image is larger then screen
			if ((image.width + this.lightbox_fullSpace) > this.viewport['width']) {
				var imgWidth = this.viewport['width'] - this.lightbox_fullSpace;
				var imgHeight = (image.height * imgWidth) / image.width;
			} else {
				var imgWidth = image.width;
				var imgHeight = image.height;
			}

			if ((imgHeight + this.lightbox_fullSpace) > this.viewport['height']) {
				imgWidth = (imgWidth * (this.viewport['height'] - this.lightbox_fullSpace)) / imgHeight;
				imgHeight = this.viewport['height'] - this.lightbox_fullSpace;
			}

			// set title
			$(id_viewer_title).setStyle({
				top: (imgHeight + lightbox_border) + 'px',
				width: (imgWidth - lightbox_border) + 'px'
			}).update(this.imgTitle);;
			
			// hide img loading
			window.imgViewer_aniProcessing.seekTo(0);

			// resize box
			this.resize(image.src, imgWidth, imgHeight);

			// set position
			this.position = positionPrev;
		} else {
			setTimeout("myViewer.prev()",50);
		}
		
	},
	
	show: function() {
		if ($(id_viewer_overlay).style.display == 'block') {
			window.imgViewer_aniViewer.seekTo(1);
			window.imgViewer_aniLoading.seekTo(0);
		} else {
			setTimeout("myViewer.show()",50);
		}
	},
	
	hide: function() {
		window.imgViewer_aniViewer.seekTo(0);
		window.imgViewer_aniOverlay.seekTo(0);
		window.imgViewer_aniProcessing.seekTo(0);
		this.clear();
	},
	
	clear: function() {
		if ($(id_viewer_overlay).style.display == 'none') {
			// removes all child nodes
			while ($(id_viewer).firstChild) {
				$(id_viewer).removeChild($(id_viewer).firstChild);
			}
			window.imgViewer_aniLoading.seekTo(1);
		} else {
			setTimeout("myViewer.clear()",50);
		}
	},
	
	resize: function(img, x, y) {
		if ($(id_viewer_image).style.display == 'none') {
			
			x = parseInt(x);
			y = parseInt(y);
			
			var imgWidth = x + 'px';
			var imgHeight = y + 'px';
			
			var boxWidth = x + (lightbox_border * 2) + 'px';
			var boxHeight = y + (lightbox_border * 2) + 'px';
			
			var marginLeft = Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) - ((x + (lightbox_border * 2)) / 2)) + 'px';
			var marginTop = Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - ((y + (lightbox_border * 2)) / 2)) + 'px';
			
			if (this.closePosition == 'left') {
				var marginLeftClose = Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) - ((x + (lightbox_border * 2)) / 2)  - (parseInt($(id_viewer_closebox).getStyle('width')) / 2)) + 'px';
			} else {
				var marginLeftClose = Math.floor(this.scrollOffset['left'] + (this.viewport['width'] / 2) + ((x + (lightbox_border * 2)) / 2)  - (parseInt($(id_viewer_closebox).getStyle('width')) / 2)) + 'px';
			}
			var marginTopClose = Math.floor(this.scrollOffset['top'] + (this.viewport['height'] / 2) - ((y + (lightbox_border * 2)) / 2)  - (parseInt($(id_viewer_closebox).getStyle('height')) / 2)) + 'px';

			$(id_viewer_image).setAttribute('src', img);
			$(id_viewer_image).style.width = imgWidth;
			$(id_viewer_image).style.height = imgHeight;

			// resize animation
			this.resizeAnimations(boxWidth, boxHeight, marginLeft, marginTop, marginLeftClose, marginTopClose);
			window.imgViewer_aniResize.seekTo(1);

		} else {
			setTimeout("myViewer.resize('"+img+"', '"+x+"', '"+y+"')",50);
		}
	},

// --- animations (Documentation: http://berniecode.com/writing/animator.html)	
	
	basicAnimations: function() {
		
		// visibilty of the viewer
		window.imgViewer_aniViewer = new Animator({
			duration: 250
		}).addSubject(new NumericalStyleSubject(
		    $(id_viewer), 'opacity', 0, 1)
		).addSubject(this.setVisibilityViewer);
	
		// visibilty of the overlay
		window.imgViewer_aniOverlay = new Animator({
			duration: 250
		}).addSubject(new NumericalStyleSubject(
		    $(id_viewer_overlay), 'opacity', 0, 1)
		).addSubject(this.setVisibiltyOverlay);
	
		// visibility of the loading indicator
		window.imgViewer_aniLoading = new Animator({
			duration: 250
		}).addSubject(new NumericalStyleSubject(
		    $(id_viewer_loading), 'opacity', 0, 1)
		).addSubject(this.setVisibiltyLoading);
		
		// visibility of the img loading indicator
		window.imgViewer_aniProcessing = new Animator({
			duration: 250
		}).addSubject(new NumericalStyleSubject(
		    $(id_viewer_processing), 'opacity', 0, 1)
		).addSubject(this.setVisibiltyProcessing);
	},
	
	resizeAnimations: function(boxWidth, boxHeight, marginLeft, marginTop, marginLeftClose, marginTopClose) {
		window.imgViewer_aniResize = new Animator().addSubject(new CSSStyleSubject(
			$(id_viewer_container), 'width: '+boxWidth+'; height: '+boxHeight+'; margin-left: '+marginLeft+'; margin-top: '+marginTop+';')
		).addSubject(new CSSStyleSubject(
			$(id_viewer_closebox), 'margin-left: '+marginLeftClose+'; margin-top: '+marginTopClose+';')
		).addSubject(this.showImage);
	},
	
	imgAnimations: function() {
		
		// visibilty of the image
		window.imgViewer_aniImage = new Animator({
			duration: 250
		}).addSubject(new NumericalStyleSubject(
		    $(id_viewer_image), 'opacity', 0, 1)
		).addSubject(new NumericalStyleSubject(
			$(id_viewer_navi_left), 'opacity', 0.2, 1)
		).addSubject(new NumericalStyleSubject(
			$(id_viewer_navi_right), 'opacity', 0.2, 1)
		).addSubject(
			this.setVisibiltyImage
		);
		
		// visibilty of the title
		window.imgViewer_aniTitle = new Animator({
			duration: 250
		}).addSubject(	new CSSStyleSubject(
			$(id_viewer_title), 'height: '+lightbox_title_lineheight+'px; margin-top: -'+lightbox_title_lineheight+'px')
		);
		
	},
	
	showImage: function(value) {
		if(value == 1) {
			window.imgViewer_aniImage.seekTo(1);
		}
	},
	
	setVisibilityViewer: function(value) {
		if(value == 0) {
			$(id_viewer).setStyle({ display: 'none' });
		} else {
			$(id_viewer).setStyle({ display: 'block' });
		}
	},
	
	setVisibiltyOverlay: function(value) {
		if(value == 0) {
			$(id_viewer_overlay).setStyle({ display: 'none' });
		} else {
			$(id_viewer_overlay).setStyle({ display: 'block' });
		}
	},
	
	setVisibiltyLoading: function(value) {
		if(value == 0) {
			$(id_viewer_loading).setStyle({ display: 'none' });
		} else {
			$(id_viewer_loading).setStyle({ display: 'block' });
		}
	},
	
	setVisibiltyProcessing: function(value) {
		if(value == 0) {
			$(id_viewer_processing).setStyle({ display: 'none' });
		} else {
			$(id_viewer_processing).setStyle({ display: 'block' });
		}
	},
	
	setVisibiltyImage: function(value) {
		if(value == 0) {
			$(id_viewer_image).setStyle({ display: 'none' });
		} else {
			$(id_viewer_image).setStyle({ display: 'block' });
		}
	}
	
}

// --- END

/******************************************************************************
Name:    Carousel Viewer
Version: 0.8 (March 30 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
Carousel Viewer is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/

// --- nomenclature

var id_carousel = 						'carousel';
var id_carousel_item_title = 			'carousel_itemTitle';
var id_carousel_navi = 					'carousel_navi';
var id_carousel_navi_play = 			'carousel_naviPlay';
var id_carousel_list_item_prefix = 		'carousel_posItem_';
var id_carousel_image_prefix = 			'carousel_posImage_';
var id_carousel_reflection_prefix = 	'carousel_posReflection_';

var class_carousel_list = 				'carousel_list';
var class_carousel_list_item = 			'carousel_item';
var class_carousel_navi_play = 			'icon_play';
var class_carousel_navi_pause =			'icon_pause';
var class_carousel_navi_left =			'icon_left';
var class_carousel_navi_fastLeft =		'icon_fastLeft';
var class_carousel_navi_center =		'icon_center';
var class_carousel_navi_right = 		'icon_right';
var class_carousel_navi_fastRight = 	'icon_fastRight';

var class_opacity_100 = 				'opacity_100';
var class_opacity_30 = 					'opacity_30';
var class_opacity_15 = 					'opacity_15';
var class_opacity_0 = 					'opacity_0';

var folder_content = 					'content/';
var folder_cache = 						'cache/';
var file_reflection_prefix = 			'reflect_';

// --- class

Carousel = Class.create();

Carousel.prototype = {
	
	initialize: function(wrapper, options) {
		
		var carousel = this;
		
		this.wrapper = wrapper;
		
		// options
		this.options = options || {};
		this.animationTime = this.options.animationTime;
		this.waitTime = this.options.waitTime;
		this.fastAnimationTime = this.options.fastAnimationTime;
		this.fastWaitTime = this.options.fastWaitTime;
		this.saveTime = this.options.saveTime;
		this.displayTitle = this.options.displayTitle;
		this.carouselWidth = this.options.carouselWidth;
		this.carouselHeight = this.options.carouselHeight;
		this.reflectionHeight = this.options.reflectionHeight;
		this.reflectionTopMargin = this.options.reflectionTopMargin;
		this.imgSourceType = this.options.imgSourceType;
		this.imgSource = this.options.imgSource;
		
		// vars
		this.position = 0;
		this.elements = 0;
		this.imgArray = [];
		this.animationRunning = false;
		this.breakGoto = false;
		this.activeNavigation = true;
		this.direction = '';
		this.oldAnimationTime = this.animationTime;
		this.oldWaitTime = this.waitTime;
		this.timestamp = new Date().getTime();

		this.initialized = true;
		
		this.build();
		
	},
	
	build: function() {
		
		// vars
		var complete = 0;
		
		// get the content
		if (this.imgSourceType == 'href') {
			
			// vars
			var items = $(this.imgSource).getElementsByTagName('a');

			// set elements counter
			this.elements = items.length;
			
			// build array
			for (var i=0, j=items.length; i<j; i+=1) {
				this.imgArray[i] = new Image();
				this.imgArray[i].src = items[i].firstChild.getAttribute('src');
				this.imgArray[i].reflection = items[i].firstChild.getAttribute('src').replace('output=img','output=refl');
				this.imgArray[i].href = items[i].href;
				this.imgArray[i].title = items[i].title;

				if (this.imgArray[i].complete === true) {
					complete += 1;
				}
			}
			
		} else if (this.imgSourceType == 'array') {
			
			// set elements counter
			this.elements = this.imgSource.length;
			
			// img array
			this.imgArray = this.imgSource;
			
			// check if images are fully loaded
			for (var i=0, j=this.elements; i<j; i+=1) {
				if (this.imgArray[i].complete === true) {
					complete += 1;
				}
			}

		}
		
		// build elements
		if(!$(id_carousel)) {
			
			var objCarousel = new Element('div', { id: id_carousel }).setStyle({
				position: 'absolute',
				width: this.carouselWidth + 'px',
				height: this.carouselHeight + 'px',
				left: '0px',
				top: '0px'
			});
			$(this.wrapper).appendChild(objCarousel);	
			
		} else {
			clearContent(id_carousel);
			var objCarousel = $(id_carousel);
		}
		
		var objCarouselPlayButton = new Element('div', { 'class': class_carousel_navi_play, id: id_carousel_navi_play });
		objCarousel.appendChild(objCarouselPlayButton);
		
		var objCarouselImgTitle = new Element('div', { id: id_carousel_item_title });
		objCarousel.appendChild(objCarouselImgTitle);
		
		var objCarouselList = new Element('ul', { 'class': class_carousel_list });
		objCarousel.appendChild(objCarouselList);
		
		var objCarouselIcon = new Element('div', { id: id_carousel_navi }).setStyle({
			backgroundColor: 'transparent',
			backgroundRepeat: 'no-repeat',
			backgroundPosition: 'top left'
		});
		objCarousel.appendChild(objCarouselIcon);
		
		Event.observe(objCarouselPlayButton, 'mousedown', this.play.bindAsEventListener(this));
		Event.observe(objCarouselIcon, 'mousedown', this.click.bindAsEventListener(this));
		Event.observe(objCarouselIcon, 'mousemove', this.iconHover.bindAsEventListener(this));
		
		// write carousel content
		if(complete == this.elements) {
			for (var i=0, j=this.imgArray.length; i<j; i+=1) {
				
				// calculate image sizes
				var itemWidth = this.imgArray[i].width;
				var itemHeight = this.imgArray[i].height + this.reflectionHeight + this.reflectionTopMargin;

				var maxWidth = (this.carouselWidth / 10) * 4;
				var maxHeight = (maxWidth * itemHeight) / itemWidth;

				if (maxHeight > this.carouselHeight) {
					maxWidth = (maxWidth * this.carouselHeight) / maxHeight;
					maxHeight = this.carouselHeight;
				}

				var factor = maxHeight / itemHeight;

				this.imgArray[i].maxWidth = maxWidth;
				this.imgArray[i].maxHeight = maxHeight;
				this.imgArray[i].factor = factor;

				// set title
				if ((i == 0) && (this.displayTitle === true)) {
					$(id_carousel_item_title).setStyle({
						width: (maxWidth - 10) + 'px',
						height: '30px',
						lineHeight: '30px',
						marginTop: (this.imgArray[i].height * factor) + ((this.carouselHeight - maxHeight) / 2) + 'px',
						marginLeft: ((this.carouselWidth / 10) * 3) + Math.floor((((this.carouselWidth / 10) * 4) - maxWidth) / 2) + 5 + 'px'
					});
					var textTitle = document.createTextNode(this.imgArray[i].title);
					$(id_carousel_item_title).appendChild(textTitle);
				}
				
				// build carousel content
				if (i == 0) {
					
					var objCarouselListItem = new Element('li', { 'class': (class_carousel_list_item + ' ' + class_opacity_100), id: (id_carousel_list_item_prefix + i) }).setStyle({
						width: ((this.carouselWidth / 10) * 4) + 'px',
						height: maxHeight + 'px',
						marginTop: ((this.carouselHeight - maxHeight) / 2) + 'px',
						marginLeft: ((this.carouselWidth / 10) * 3) + Math.floor((((this.carouselWidth / 10) * 4) - maxWidth) / 2) + 'px',
						opacity: 1.0
					});
					objCarouselList.appendChild(objCarouselListItem);
					
					var objCarouselLink = new Element('a', { 'class': (lightbox_marker + '_' + this.timestamp), href: this.imgArray[i].href, alt: this.imgArray[i].title });
					objCarouselListItem.appendChild(objCarouselLink);
					objCarouselLink.onclick = function() {return false;};
					
					var objCarouselImg = new Element('img', { src: this.imgArray[i].src, id: (id_carousel_image_prefix + i) }).setStyle({
						width: maxWidth + 'px',
						height: (this.imgArray[i].height * factor) + 'px'
					});
					objCarouselLink.appendChild(objCarouselImg);
					
					var objCarouselReflection = new Element('img', { src: this.imgArray[i].reflection, id: (id_carousel_reflection_prefix + i) }).setStyle({
						width: maxWidth + 'px',
						height: (this.reflectionHeight * factor) + 'px',
						marginTop: this.reflectionTopMargin + 'px'
					});
					objCarouselListItem.appendChild(objCarouselReflection);

				} else if (i == (1)) {
					
					var objCarouselListItem = new Element('li', { 'class': (class_carousel_list_item + ' ' + class_opacity_30), id: (id_carousel_list_item_prefix + i) }).setStyle({
						width: ((this.carouselWidth / 10) * 2) + 'px',
						height: (maxHeight / 2) + 'px',
						marginTop: ((this.carouselHeight - (maxHeight / 2)) / 2) + 'px',
						marginLeft: (this.carouselWidth / 10) + Math.floor((((this.carouselWidth / 10) * 2) - (maxWidth / 2)) / 2) + 'px',
						opacity: 0.3
					});
					objCarouselList.appendChild(objCarouselListItem);
					
					var objCarouselLink = new Element('a', { 'class': (lightbox_marker + '_' + this.timestamp), href: this.imgArray[i].href, alt: this.imgArray[i].title });
					objCarouselListItem.appendChild(objCarouselLink);
					objCarouselLink.onclick = function() {return false;};
					
					var objCarouselImg = new Element('img', { src: this.imgArray[i].src, id: (id_carousel_image_prefix + i) }).setStyle({
						width: (maxWidth / 2) + 'px',
						height: ((this.imgArray[i].height * factor) / 2) + 'px'
					});
					objCarouselLink.appendChild(objCarouselImg);
					
					var objCarouselReflection = new Element('img', { src: this.imgArray[i].reflection, id: (id_carousel_reflection_prefix + i) }).setStyle({
						width: (maxWidth / 2) + 'px',
						height: ((this.reflectionHeight * factor) / 2) + 'px',
						marginTop: this.reflectionTopMargin + 'px'
					});
					objCarouselListItem.appendChild(objCarouselReflection);

				} else if (i == (2)) {
					
					var objCarouselListItem = new Element('li', { 'class': (class_carousel_list_item + ' ' + class_opacity_15), id: (id_carousel_list_item_prefix + i) }).setStyle({
						width: (this.carouselWidth / 10) + 'px',
						height: (maxHeight / 4) + 'px',
						marginTop: ((this.carouselHeight - (maxHeight / 4)) / 2) + 'px',
						marginLeft:  Math.floor(((this.carouselWidth / 10) - (maxWidth / 4)) / 2) + 'px',
						opacity: 0.15
					});
					objCarouselList.appendChild(objCarouselListItem);
					
					var objCarouselLink = new Element('a', { 'class': (lightbox_marker + '_' + this.timestamp), href: this.imgArray[i].href, alt: this.imgArray[i].title });
					objCarouselListItem.appendChild(objCarouselLink);
					objCarouselLink.onclick = function() {return false;};
					
					var objCarouselImg = new Element('img', { src: this.imgArray[i].src, id: (id_carousel_image_prefix + i) }).setStyle({
						width: (maxWidth / 4) + 'px',
						height: ((this.imgArray[i].height * factor) / 4) + 'px'
					});
					objCarouselLink.appendChild(objCarouselImg);
					
					var objCarouselReflection = new Element('img', { src: this.imgArray[i].reflection, id: (id_carousel_reflection_prefix + i) }).setStyle({
						width: (maxWidth / 4) + 'px',
						height: ((this.reflectionHeight * factor) / 4) + 'px',
						marginTop: this.reflectionTopMargin + 'px'
					});
					objCarouselListItem.appendChild(objCarouselReflection);

				} else {
					
					var objCarouselListItem = new Element('li', { 'class': (class_carousel_list_item + ' ' + class_opacity_0), id: (id_carousel_list_item_prefix + i) }).setStyle({
						width: '0px',
						height: '0px',
						marginTop: (this.carouselHeight / 2) + 'px',
						marginLeft: '0px',
						opacity: 0.0
					});
					objCarouselList.appendChild(objCarouselListItem);
					
					var objCarouselLink = new Element('a', { 'class': (lightbox_marker + '_' + this.timestamp), href: this.imgArray[i].href, alt: this.imgArray[i].title });
					objCarouselListItem.appendChild(objCarouselLink);
					objCarouselLink.onclick = function() {return false;};
					
					var objCarouselImg = new Element('img', { src: this.imgArray[i].src, id: (id_carousel_image_prefix + i) }).setStyle({
						width: '0px',
						height: '0px'
					});
					objCarouselLink.appendChild(objCarouselImg);
					
					var objCarouselReflection = new Element('img', { src: this.imgArray[i].reflection, id: (id_carousel_reflection_prefix + i) }).setStyle({
						width: '0px',
						height: '0px',
						marginTop: '0px'
					});
					objCarouselListItem.appendChild(objCarouselReflection);

				}
				
				// set event listner
				Event.observe(objCarouselListItem, 'mousemove', this.iconHover.bindAsEventListener(this));
				Event.observe(objCarouselListItem, 'mouseout', this.iconHide.bindAsEventListener(this));
				Event.observe(objCarouselLink, 'mousedown', this.click.bindAsEventListener(this));
				
			}
			
			// initialize the viewer
			myViewer = new imgViewer({
				marker: lightbox_marker + '_' + this.timestamp,
				close: lightbox_close,
				listner: false
			});
			
			// add some empty values for the animation
			this.imgArray[this.elements] = 0;
			this.imgArray[this.elements+1] = 0;
			this.imgArray[this.elements+2] = 0;
			this.imgArray[this.elements+3] = 0;
			this.imgArray[-1] = 0;
			this.imgArray[-2] = 0;
			this.imgArray[-3] = 0;

			// create animation effects
			this.buildAnimations();
			
		} else {
			setTimeout('myCarousel.build()',250);
		}
	},
	
	// -------------------------------------------------------------------------------------------------------
	// NAVIGATION
	// -------------------------------------------------------------------------------------------------------
	
	// play button
	play: function() {
		if (this.activeNavigation === true) {
			if (this.animationRunning === false) {
				if (this.position < this.elements-1) {
					this.doAnimation('forward');
				} else {
					this.doAnimation('backward');
				}
			} else {
				this.stopAnimation();
				this.breakGoto = true;
			}
		}
	},
	
	// play button status
	switchPlayButton: function(state) {
		if (state == 'play') {
			$(id_carousel_navi_play).className = class_carousel_navi_play;
		} else if (state == 'pause') {
			$(id_carousel_navi_play).className = class_carousel_navi_pause;
		}
	},
	
	// carousel items
	click: function(e) {
		
		e = e || window.event;
		Event.stop(e); // doesn't work in safai 2.0.3

		if (this.activeNavigation === true) {
			if (this.animationRunning === true) {
				this.stopAnimation();
			}

			var mouseX = this.getMouseX(e);
			var offset = $(id_carousel).viewportOffset();
			var mousePosition = mouseX-offset[0];

			if (mousePosition < (this.carouselWidth/10)) {
				this.gotoPosition(this.position+2, 'start');
			} else if (mousePosition < ((this.carouselWidth/10) * 3)) {
				this.moveForward();
			} else if (mousePosition < ((this.carouselWidth/10) * 7)) {
				myViewer.load($(id_carousel_list_item_prefix+this.position).firstChild);
			} else if (mousePosition < ((this.carouselWidth/10) * 9)) {
				this.moveBackward();
			} else {
				this.gotoPosition(this.position-2, 'start');
			}
			
		}
		
	},
	
	// carousel icons
	iconHover: function(e) {
		if (this.animationRunning === false) {
			
			e = e || window.event;
			
			var mouseX = this.getMouseX(e);
			var offset = $(id_carousel).viewportOffset();
			var mousePosition = mouseX - offset[0];
			var maxWidth = (this.carouselWidth / 10) * 4;
			var iconHeight = parseInt(Element.getStyle(id_carousel_navi, 'height'));
			var iconWidth = parseInt(Element.getStyle(id_carousel_navi, 'width'));

			if (mousePosition < (this.carouselWidth/10)) {
				if (this.position < this.elements-2) {
					$(id_carousel_navi).className = class_carousel_navi_fastLeft;
					$(id_carousel_navi).setStyle({
						marginTop: (this.carouselHeight / 2) - (((this.reflectionHeight * this.imgArray[this.position+2].factor) / 8) + (iconHeight / 2)) + 'px',
						marginLeft: (maxWidth / 8) - (iconWidth / 2) + 'px',
						display: 'block'
					});
				}
			} else if (mousePosition < ((this.carouselWidth/10) * 3)) {
				if (this.position < this.elements-1) {
					$(id_carousel_navi).className = class_carousel_navi_left;
					$(id_carousel_navi).setStyle({
						marginTop: (this.carouselHeight / 2) - (((this.reflectionHeight * this.imgArray[this.position+1].factor) / 4) + (iconHeight / 2)) + 'px',
						marginLeft: ((this.carouselWidth/10) * 3) - (maxWidth / 4) - (iconWidth / 2) + 'px',
						display: 'block'
					});
				}
			} else if (mousePosition < ((this.carouselWidth/10) * 7)) {
				$(id_carousel_navi).className = class_carousel_navi_center;
				$(id_carousel_navi).setStyle({
					marginTop: (this.carouselHeight / 2) - (((this.reflectionHeight * this.imgArray[this.position].factor) / 2) + (iconHeight / 2)) + 'px',
					marginLeft: ((this.carouselWidth/10) * 7) - (maxWidth / 2) - (iconWidth / 2) + 'px',
					display: 'block'
				});
			} else if (mousePosition < ((this.carouselWidth/10) * 9)) {
				if (this.position > 0) {
					$(id_carousel_navi).className = class_carousel_navi_right;
					$(id_carousel_navi).setStyle({
						marginTop: (this.carouselHeight / 2) - (((this.reflectionHeight * this.imgArray[this.position-1].factor) / 4) + (iconHeight / 2)) + 'px',
						marginLeft: ((this.carouselWidth/10) * 9) - (maxWidth / 4) - (iconWidth / 2) + 'px',
						display: 'block'
					});
				}
			} else {
				if (this.position > 1) {
					$(id_carousel_navi).className = class_carousel_navi_fastRight;
					$(id_carousel_navi).setStyle({
						marginTop: (this.carouselHeight / 2) - (((this.reflectionHeight * this.imgArray[this.position-2].factor) / 8) + (iconHeight / 2)) + 'px',
						marginLeft: this.carouselWidth - (maxWidth / 8) - (iconWidth / 2) + 'px',
						display: 'block'
					});
				}
			}
		}
	},
	
	iconHide: function() {
		$(id_carousel_navi).setStyle({
			display: 'none'
		});
	},

	// activate navigation
	activateNavigation: function() {
		this.activeNavigation = true;
		window.aniCarouselPlayButton.seekTo(1);
	},

	// deactivate navigation
	deactivateNavigation: function() {
		this.activeNavigation = false;
		window.aniCarouselPlayButton.seekTo(0.6);
	},
	
	getMouseX: function(e){
		
		e = e || window.event;
		
		var posX = 0;
		
		if (e.pageX != undefined) {
			posX = e.pageX;
		} else if (e.clientX != undefined) {
			posX = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
		}
		return posX;
	},
	
	// -------------------------------------------------------------------------------------------------------
	// TITLE
	// -------------------------------------------------------------------------------------------------------
	
	// hide image title
	aniImgTitle: function(action, speed) {
		if (speed == 'normal') {
			window.aniCarouselImgTitle.seekTo(0);
		} else {
			window.aniCarouselImgTitleFast.seekTo(0);
		}
		setTimeout('myCarousel.updateImgTitle("'+action+'","'+speed+'")', (this.animationTime+this.saveTime));
	},
	
	// change and display image title
	updateImgTitle: function(action, speed) {
		if (action == 'forward') {
			
			$(id_carousel_item_title).setStyle({
				width: this.imgArray[this.position+1].maxWidth - 10 + 'px',
				height: '30px',
				lineHeight: '30px',
				marginTop: (this.imgArray[this.position+1].height * this.imgArray[this.position+1].factor) + ((this.carouselHeight - this.imgArray[this.position+1].maxHeight) / 2) + 'px',
				marginLeft: ((this.carouselWidth / 10) * 3) + Math.floor((((this.carouselWidth / 10) * 4) - this.imgArray[this.position+1].maxWidth) / 2) + 5 + 'px'
			});

			while ($(id_carousel_item_title).firstChild) {
				$(id_carousel_item_title).removeChild($(id_carousel_item_title).firstChild);
			}

			var textTitle = document.createTextNode(this.imgArray[this.position+1].title);
			$(id_carousel_item_title).appendChild(textTitle);

		} else if (action == 'backward') {
			
			$(id_carousel_item_title).setStyle({
				width: this.imgArray[this.position-1].maxWidth - 10 + 'px',
				height: '30px',
				lineHeight: '30px',
				marginTop: (this.imgArray[this.position-1].height * this.imgArray[this.position-1].factor) + ((this.carouselHeight - this.imgArray[this.position-1].maxHeight) / 2) + 'px',
				marginLeft: ((this.carouselWidth / 10) * 3) + Math.floor((((this.carouselWidth / 10) * 4) - this.imgArray[this.position-1].maxWidth) / 2) + 5 + 'px'
			});

			while ($(id_carousel_item_title).firstChild) {
				$(id_carousel_item_title).removeChild($(id_carousel_item_title).firstChild);
			}

			var textTitle = document.createTextNode(this.imgArray[this.position-1].title);
			$(id_carousel_item_title).appendChild(textTitle);

		}

		if (speed == 'normal') {
			window.aniCarouselImgTitle.seekTo(1);
		} else {
			window.aniCarouselImgTitleFast.seekTo(1);
		}
	},
	
	// -------------------------------------------------------------------------------------------------------
	// ANIMATION
	// -------------------------------------------------------------------------------------------------------
	
	buildAnimations: function() {
		
		// rotate forward
		window.rotateForward = new Animator({
			duration: this.animationTime
		}
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position+3)), 'position: absolute; height: '+(this.imgArray[this.position+3].maxHeight / 4)+'px; width: '+(this.carouselWidth / 10)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position+3].maxHeight / 4))/2)+'px; margin-left: '+Math.floor(0 + (((this.carouselWidth / 10) - (this.imgArray[this.position+3].maxWidth / 4)) / 2))+'px; opacity: 0.15;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position+3)), 'height: '+((this.imgArray[this.position+3].height * this.imgArray[this.position+3].factor) / 4)+'px; width: '+(this.imgArray[this.position+3].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position+3)), 'height: '+((this.reflectionHeight * this.imgArray[this.position+3].factor) / 4)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position+3].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position+2)), 'position: absolute; height: '+(this.imgArray[this.position+2].maxHeight / 2)+'px; width: '+((this.carouselWidth / 10) * 2)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position+2].maxHeight / 2))/2)+'px; margin-left: '+Math.floor((this.carouselWidth / 10) + ((((this.carouselWidth / 10) * 2) - (this.imgArray[this.position+2].maxWidth / 2)) / 2))+'px; opacity: 0.3;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position+2)), 'height: '+((this.imgArray[this.position+2].height * this.imgArray[this.position+2].factor) / 2)+'px; width: '+(this.imgArray[this.position+2].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position+2)), 'height: '+((this.reflectionHeight * this.imgArray[this.position+2].factor) / 2)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position+2].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position+1)), 'position: absolute; height: '+this.imgArray[this.position+1].maxHeight+'px; width: '+((this.carouselWidth / 10) * 4)+'px; margin-top: '+((this.carouselHeight-this.imgArray[this.position+1].maxHeight)/2)+'px; margin-left: '+Math.floor(((this.carouselWidth / 10) * 3) + ((((this.carouselWidth / 10) * 4) - (this.imgArray[this.position+1].maxWidth)) / 2))+'px; opacity: 1.0;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position+1)), 'height: '+(this.imgArray[this.position+1].height * this.imgArray[this.position+1].factor)+'px; width: '+(this.imgArray[this.position+1].maxWidth)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position+1)), 'height: '+(this.reflectionHeight * this.imgArray[this.position+1].factor)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position+1].maxWidth)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+this.position), 'position: absolute; height: '+(this.imgArray[this.position].maxHeight / 2)+'px; width: '+((this.carouselWidth / 10) * 2)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position].maxHeight / 2))/2)+'px; margin-left: '+Math.floor(((this.carouselWidth / 10) * 7) + ((((this.carouselWidth / 10) * 2) - (this.imgArray[this.position].maxWidth / 2)) / 2))+'px; opacity: 0.3;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position)), 'height: '+((this.imgArray[this.position].height * this.imgArray[this.position].factor) / 2)+'px; width: '+(this.imgArray[this.position].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position)), 'height: '+((this.reflectionHeight * this.imgArray[this.position].factor) / 2)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position-1)), 'position: absolute; height: '+(this.imgArray[this.position-1].maxHeight / 4)+'px; width: '+(this.carouselWidth / 10)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position-1].maxHeight / 4))/2)+'px; margin-left: '+Math.floor(((this.carouselWidth / 10) * 9) + (((this.carouselWidth / 10) - (this.imgArray[this.position-1].maxWidth / 4)) / 2))+'px; opacity: 0.15;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position-1)), 'height: '+((this.imgArray[this.position-1].height * this.imgArray[this.position-1].factor) / 4)+'px; width: '+(this.imgArray[this.position-1].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position-1)), 'height: '+((this.reflectionHeight * this.imgArray[this.position-1].factor) / 4)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position-1].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position-2)), 'position: absolute; height: 0px; width: 0px; margin-top: '+(this.carouselHeight / 2)+'px; margin-left: '+this.carouselWidth+'px; opacity: 0.0;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position-2)), 'height: 0px; width: 0px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position-2)), 'height: 0px; margin-top: 0px; width: 0px;')
		);
		
		// rotate backward
		window.rotateBackward = new Animator({
			duration: this.animationTime
		}
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position+2)), 'position: absolute; height: 0px; width: 0px; margin-top: '+(this.carouselHeight / 2)+'px; margin-left: 0px; opacity: 0.0;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position+2)), 'height: 0px; width: 0px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position+2)), 'height: 0px; margin-top: 0px; width: 0px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position+1)), 'position: absolute; height: '+(this.imgArray[this.position+1].maxHeight / 4)+'px; width: '+(this.carouselWidth / 10)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position+1].maxHeight / 4))/2)+'px; margin-left: '+Math.floor(0 + (((this.carouselWidth / 10) - (this.imgArray[this.position+1].maxWidth / 4)) / 2))+'px; opacity: 0.15;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position+1)), 'height: '+((this.imgArray[this.position+1].height * this.imgArray[this.position+1].factor) / 4)+'px; width: '+(this.imgArray[this.position+1].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position+1)), 'height: '+((this.reflectionHeight * this.imgArray[this.position+1].factor) / 4)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position+1].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+this.position), 'position: absolute; height: '+(this.imgArray[this.position].maxHeight / 2)+'px; width: '+((this.carouselWidth / 10) * 2)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position].maxHeight / 2))/2)+'px; margin-left: '+Math.floor((this.carouselWidth / 10) + ((((this.carouselWidth / 10) * 2) - (this.imgArray[this.position].maxWidth / 2)) / 2))+'px; opacity: 0.3;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position)), 'height: '+((this.imgArray[this.position].height * this.imgArray[this.position].factor) / 2)+'px; width: '+(this.imgArray[this.position].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position)), 'height: '+((this.reflectionHeight * this.imgArray[this.position].factor) / 2)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position-1)), 'position: absolute; height: '+this.imgArray[this.position-1].maxHeight+'px; width: '+((this.carouselWidth / 10) * 4)+'px; margin-top: '+((this.carouselHeight-this.imgArray[this.position-1].maxHeight)/2)+'px; margin-left: '+Math.floor(((this.carouselWidth / 10) * 3) + ((((this.carouselWidth / 10) * 4) - (this.imgArray[this.position-1].maxWidth)) / 2))+'px; opacity: 1.00;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position-1)), 'height: '+((this.imgArray[this.position-1].height * this.imgArray[this.position-1].factor))+'px; width: '+(this.imgArray[this.position-1].maxWidth)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_reflection_prefix+(this.position-1)), 'height: '+(this.reflectionHeight * this.imgArray[this.position-1].factor)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position-1].maxWidth)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position-2)), 'position: absolute; height: '+(this.imgArray[this.position-2].maxHeight / 2)+'px; width: '+((this.carouselWidth / 10) * 2)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position-2].maxHeight / 2))/2)+'px; margin-left: '+Math.floor(((this.carouselWidth / 10) * 7) + ((((this.carouselWidth / 10) * 2) - (this.imgArray[this.position-2].maxWidth / 2)) / 2))+'px; opacity: 0.3;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_image_prefix+(this.position-2)), 'height: '+((this.imgArray[this.position-2].height * this.imgArray[this.position-2].factor) / 2)+'px; width: '+(this.imgArray[this.position-2].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(	
			$(id_carousel_reflection_prefix+(this.position-2)), 'height: '+((this.reflectionHeight * this.imgArray[this.position-2].factor) / 2)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position-2].maxWidth / 2)+'px;')
		).addSubject(new CSSStyleSubject(
			$(id_carousel_list_item_prefix+(this.position-3)), 'position: absolute; height: '+(this.imgArray[this.position-3].maxHeight / 4)+'px; width: '+(this.carouselWidth / 10)+'px; margin-top: '+((this.carouselHeight-(this.imgArray[this.position-3].maxHeight / 4))/2)+'px; margin-left: '+Math.floor(((this.carouselWidth / 10) * 9) + (((this.carouselWidth / 10) - (this.imgArray[this.position-3].maxWidth / 4)) / 2))+'px; opacity: 0.15;')
		).addSubject(new CSSStyleSubject(	
			$(id_carousel_image_prefix+(this.position-3)), 'height: '+((this.imgArray[this.position-3].height * this.imgArray[this.position-3].factor) / 4)+'px; width: '+(this.imgArray[this.position-3].maxWidth / 4)+'px;')
		).addSubject(new CSSStyleSubject(	
			$(id_carousel_reflection_prefix+(this.position-3)), 'height: '+((this.reflectionHeight * this.imgArray[this.position-3].factor) / 4)+'px; margin-top: '+this.reflectionTopMargin+'px; width: '+(this.imgArray[this.position-3].maxWidth / 4)+'px;')
		);
		
		// image title animation
		window.aniCarouselImgTitle = new Animator({
			duration: (this.animationTime / 2)
		}).addSubject(new NumericalStyleSubject(
		    $(id_carousel_item_title), 'opacity', 0, 1)
		);
	
		window.aniCarouselImgTitleFast = new Animator({
			duration: 50
		}).addSubject(new NumericalStyleSubject(
		    $(id_carousel_item_title), 'opacity', 0, 1)
		);
		
		// play button animation
		window.aniCarouselPlayButton = new Animator({
			duration: 50
		}).addSubject(new NumericalStyleSubject(
		    $(id_carousel_navi_play), 'opacity', 0, 1)
		);
		
	},
	
	// build the new animations for the next step
	update: function(action) {
		if (action == 'forward') {	
			this.position+=1;
		} else if (action == 'backward') {
			this.position-=1;
		}
		this.buildAnimations();
	},
	
	// animates the carousel forward or backward
	doAnimation: function(action) {
		if (this.animationRunning === false) {
			this.animationRunning = true;
			this.switchPlayButton('pause');
		}

		if (action == 'forward') {
			window.rotateForward.seekTo(1);
			this.aniImgTitle('forward', 'normal');
			setTimeout('myCarousel.update("forward")', this.animationTime+this.saveTime);
			if (this.position < this.elements-2) {
				this.animation = setTimeout('myCarousel.doAnimation("forward")', this.animationTime+this.waitTime+this.saveTime);
			} else {
				this.stopAnimation();
			}
		} else if (action == 'backward') {
			window.rotateBackward.seekTo(1);
			this.aniImgTitle('backward', 'normal');
			setTimeout('myCarousel.update("backward")', this.animationTime+this.saveTime);
			if (this.position > 1) {
				this.animation = setTimeout('myCarousel.doAnimation("backward")', this.animationTime+this.waitTime+this.saveTime);
			} else {
				this.stopAnimation();
			}
		}
	},
	
	// stops the animation
	stopAnimation: function() {
		this.animationRunning = false;
		clearTimeout(this.animation);
		setTimeout('myCarousel.switchPlayButton("play")', this.animationTime+this.saveTime);
	},
	
	// move the carousel one step forward
	moveForward: function() {
		if (this.animationRunning === true) {
			this.stopAnimation();
		}
		this.deactivateNavigation();
		this.iconHide();
		window.rotateForward.seekTo(1);
		this.aniImgTitle('forward', 'normal');
		setTimeout('myCarousel.update("forward")', this.animationTime+this.saveTime);
		setTimeout('myCarousel.activateNavigation()', this.animationTime+this.saveTime);
	},
	
	// move the carousel on step backward
	moveBackward: function() {
		if (this.animationRunning === true) {
			this.stopAnimation();
		}
		this.deactivateNavigation();
		this.iconHide();
		window.rotateBackward.seekTo(1);
		this.aniImgTitle('backward', 'normal');
		setTimeout('myCarousel.update("backward")', this.animationTime+this.saveTime);
		setTimeout('myCarousel.activateNavigation()', this.animationTime+this.saveTime);
	},
	
	// fast animation to position
	gotoPosition: function(targetPosition, status) {

		if (status == 'start') {

			if (this.animationRunning === false) {

				// deactivate navigation
				this.deactivateNavigation();

				// set times
				this.oldAnimationTime = this.animationTime;
				this.oldWaitTime = this.waitTime;
				this.animationTime = this.fastAnimationTime;
				this.waitTime = this.fastWaitTime;

				// build fast animations
				this.buildAnimations();

				// direction
				if(targetPosition < 0) {
					targetPosition = 0;
				}

				if(targetPosition > this.imgArray.length-5) {
					targetPosition = this.imgArray.length-5;
				}

				if(targetPosition > this.position) {
					direction = 'forward';
					this.animationRunning = true;
				} else if (targetPosition < this.position) {
					direction = 'backward';
					this.animationRunning = true;
				} else {
					this.animationTime = this.oldAnimationTime;
					this.waitTime = this.oldWaitTime;
					this.buildAnimations();
					this.activateNavigation();
					return false;
				}

			} else {

				// direction
				if(targetPosition < 0) {
					targetPosition = 0;
				}

				if(targetPosition > imgArray.length-5) {
					targetPosition = imgArray.length-5;
				}

				if(targetPosition > position) {
					direction = 'forward';
					this.breakGoto = true;
				} else if (targetPosition < position) {
					direction = 'backward';
					this.breakGoto = true;
				} else {
					this.breakGoto = true;
				}

			}

		}

		if (direction == 'forward') {
			window.rotateForward.seekTo(1);
			this.aniImgTitle('forward', 'fast');
			setTimeout('myCarousel.updateGoto("forward", '+ targetPosition +')', this.animationTime+this.saveTime);
		} else if (direction == 'backward') {
			window.rotateBackward.seekTo(1);
			this.aniImgTitle('backward', 'fast');
			setTimeout('myCarousel.updateGoto("backward", '+ targetPosition +')', this.animationTime+this.saveTime);
		}

	},
	
	updateGoto: function(action, targetPosition) {
		if (action == 'forward') {	
			this.position+=1;
		} else if (action == 'backward') {
			this.position-=1;
		}

		if (this.breakGoto === false) {
			if (this.position != targetPosition) {
				this.buildAnimations();
				this.gotoPosition(targetPosition, 'recall');
			} else {
				this.animationRunning = false;
				this.animationTime = this.oldAnimationTime;
				this.waitTime = this.oldWaitTime;
				this.activateNavigation();
				this.buildAnimations();
			}
		} else {
			this.breakGoto = false;
		}
	}
	
}

// --- END

/******************************************************************************
Name:    qGallery
Version: 0.9 (March 31 2008)
Author:  Sebastian Brink
Contact: http://www.quadrifolia.de

Licence:
qGallery is licensed under a Creative Commons Attribution-Noncommercial 
3.0 License (http://creativecommons.org/licenses/by-nc/3.0/).

You are free:
	* to copy, distribute and transmit the work
	* to adapt the work

Under the following conditions:
	* Attribution. You must attribute the work in the manner specified by 
	  the author or licensor.
	* Noncommercial. You may not use this work for commercial purposes.

* For any reuse or distribution, you must make clear to others the license 
  terms of this work. 
* Any of the above conditions can be waived if you get permission from the
  copyright holder.
* Nothing in this license impairs or restricts the author's moral rights.

Your fair dealing and other rights are in no way affected by the above.
******************************************************************************/


/******************************************************************************
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
DAMAGE.
******************************************************************************/


/******************************************************************************
CREDITS: Bernard Sumption (berniecode.com), Peter-Paul Koch (quirksmode.org),
Lokesh Dhakar (huddletogether.com), Apple (apple.com), and others.
******************************************************************************/



//------------------------------------------------------------------------------------------------------------------------
// globals
//------------------------------------------------------------------------------------------------------------------------

var contentFolder = 			'';		// folder containing the images

var wrapper = 					'gallery'; 		// id of the element that should contain the gallery
var fullscreen = 				false;			// not implemented yet
var reflection =				false;			// image reflections - false / true
var showThumbs = 				true;
var showMosaic = 				false;			// not implemented yet
var showCarousel =				true;

var contentRightMargin =		10;
var contentLeftMargin =			10;

var thumbsMaxWidth = 			400;
var thumbsMaxHeight = 			400;
var thumbsMinMargin =			20;
var thumbsMarginTop =			10;

var reflectionHeight = 			50;
var reflectionTopMargin = 		2;
var reflectionColor =			'000000';
var reflectionStartAlpha =		80;
var reflectionEndAlpha =		0;

// imgLoader
var imgCounter =				0;

// error
var errorBreak = 				false;

var totalMaxHeight, totalMaxWidth, errorType, errorValue, checkObj;

//------------------------------------------------------------------------------------------------------------------------
// files
//------------------------------------------------------------------------------------------------------------------------

var xml_overview =				contentFolder+'/images/categories.xml';

//------------------------------------------------------------------------------------------------------------------------
// nomenclature
//------------------------------------------------------------------------------------------------------------------------

// main parts
var id_header = 				'gallery_header';
var id_content = 				'gallery_content';
var id_footer = 				'gallery_footer';
var id_title = 					'gallery_title';
var id_overview = 				'gallery_overview';

// animation parts
var id_loader = 				'gallery_loader';
var id_loader_ani = 			'gallery_loader_animation';

// thumbnail-view elements
var id_thumbs = 				'thumbs';
var id_thumbsList =				'thumbs_list';
var class_thumbsListItem =		'thumbs_item';
var class_thumbsImage =			'thumbs_img';
var class_thumbsReflection =	'thumbs_reflection';
var class_thumbsTitle =			'thumbs_title';

// button elements
var id_buttons =				'buttons';
var id_button_thumbs =			'viewGrid';
var id_button_mosaic =			'viewMosaic';
var id_button_carousel =		'viewCarousel';
var id_button_overview = 		'viewOverview';

//------------------------------------------------------------------------------------------------------------------------
// translations
//------------------------------------------------------------------------------------------------------------------------

if ((navigator.userLanguage) && (navigator.userLanguage.indexOf('de') > -1)) {
	var user_language = 'de';
} else if (navigator.language.indexOf('de') > -1) {
	var user_language = 'de';
}

if (user_language == 'de') {
	var lang_pictures = 'Bilder';
} else {
	var lang_pictures = 'images';
}

//------------------------------------------------------------------------------------------------------------------------
// initialize the gallery
//------------------------------------------------------------------------------------------------------------------------

function initGallery() { 
	myXML = new processXML({});
	
	myGallery = new Gallery({
		wrapper: wrapper,
		reflection: reflection,
		fullscreen: fullscreen
	});
}

Event.observe(window, 'load', initGallery, false);

//------------------------------------------------------------------------------------------------------------------------




//------------------------------------------------------------------------------------------------------------------------
// CLASS Galery
//
// initialize the gallery parts
//------------------------------------------------------------------------------------------------------------------------

Gallery = Class.create();

Gallery.prototype = {

	initialize: function(options) {
		
		var gallery = this;
		
		// options
		this.options = options || {};
		this.wrapper = this.options.wrapper;
		this.reflection = this.options.reflection;
		this.fullscreen = this.options.fullscreen;
		
		// ini builder
		myBuilder = new Builder({
			wrapper: this.wrapper,
			reflection: this.reflection
		});
		
		// start
		this.gallery();
		
	},
	
	gallery: function() {
		myBuilder.gallery();
		this.overview();
	},
	
	overview: function() {
		myBuilder.overview(xml_overview);
	},
	
	thumbs: function(xml, recall) {
		
		if (recall === false) {
			
			window.aniLoader.seekTo(1);
			setTimeout(function() {myBuilder.thumbs(xml);}, 500);
		
		} else if ((recall === true) && (errorBreak === false)) {
			
			// vars
			var imgReady = true;
			var imgElements = $$('#'+id_thumbs+' img');
			
			var imgArray = new Array();
			var startValues = new Array();
			
			// check if all images are loaded
			for (var i=0, j=imgElements.length; i<j; i+=1) {
				if (imgElements[i].complete != true) {
					imgReady = false;
				}
			}
				
			if(imgReady === false) {
				
				setTimeout(function() {myGallery.thumbs('', true);}, 250);
				
			} else {
				
				// get size of images
				imgArray = new Array();
				this.zeroTrigger = false;
				this.images = $$('.'+class_thumbsImage);
				this.titles = $$('.'+class_thumbsTitle);
				this.listItem = $$('.'+class_thumbsListItem);
				for (var i=0, j=this.images.length; i<j; i+=1) {
					imgArray[i] = new Image();
					imgArray[i].src = this.images[i].src;
					
					// safari image width and height = 0 bug
					// if ((imgArray[i].width == 0) ||Â (imgArray[i].height == 0)) {
					// 						this.zeroTrigger = true;
					// 					}
				}
				
				if (this.zeroTrigger === true) {
					
					setTimeout(function() {myGallery.thumbs('', true);}, 50);
					
				} else {
					
					for (var i=0; i<imgArray.length; i+=1) {
						startValues[i] = new Array(imgArray[i].width, imgArray[i].height);
					
						// img max values
						if (typeof totalMaxWidth == 'undefined' || imgArray[i].width > totalMaxWidth) {
							totalMaxWidth = imgArray[i].width;
						}
						if (typeof totalMaxHeight == 'undefined' || imgArray[i].height > totalMaxHeight) {
							totalMaxHeight = imgArray[i].height;
						}
					}
				
					// set reflections
					if (this.reflection === true) {
						this.reflectionImages = document.getElementsByClassName(class_thumbsReflection);
						for (var i=0, j=this.reflectionImages.length; i<j; i+=1) {
							this.reflectionImages[i].setStyle({ display: 'block' });
						}
					} else {
						this.reflectionImages = 'empty';
					}

					// ini slider
				    mySlider = new Control.Slider(id_footer, {
				        sliderValue: startSize, slider: id_slider, sliderTrack: id_sliderTrack, sliderHandle: id_sliderHandle, sliderLeftIcon: id_sliderLeftIcon, sliderRightIcon: id_sliderRightIcon
				    });
			
					// ini scroller
					if(!$(id_scroller_track)) {
						myScroller = new contentScroller(id_scroller_container, id_thumbs, {
							arrowPosition: setting_scroller_arrow,
							trackPosition: setting_track_position,
							offsetTop: setting_offset_top,
							offsetBottom: setting_offset_bottom,
							contentRightMargin: contentRightMargin,
							contentLeftMargin: contentLeftMargin
						});
					} else {
						myScroller.setContent(id_thumbs);
					}
				
					// ini buttons
					myButtons = new Control.Buttons(id_footer, {
						showThumbs: showThumbs, showMosaic: showMosaic, showCarousel: showCarousel, idButtons: id_buttons, idThumbs: id_button_thumbs, idMosaic: id_button_mosaic, idCarousel: id_button_carousel
					});
			
					// ini resize
				    myResize = new Resize(id_thumbs, {
						listItem: this.listItem,
						images: this.images,
						reflections: this.reflectionImages,
						titles: this.titles,
						startValues: startValues
					});
				
					// ini viewer
					myViewer = new imgViewer({
						marker: lightbox_marker,
						close: lightbox_close,
						listner: lightbox_listner
					});
				
					// show thumbnails
					switchView(id_thumbs);
				}

			}
		
		} else {
			if (errorType == '404') {
				alert('ERROR: image "'+errorValue+'" is missing!')
			} else if (errorType == 'failure') {
				alert('ERROR: something went wrong!' + errorType)
			}
			return true;
		}
	
	},
	
	carousel: function() {
		
		if(typeof myCarousel == 'object') {
			myCarousel.stopAnimation();
		}

		myCarousel = new Carousel(id_content, {
			animationTime: 800,
			waitTime: 1000,
			fastAnimationTime: 50,
			fastWaitTime: 0,
			saveTime: 0,
			displayTitle: true,
			carouselWidth: parseInt(Element.getStyle(id_content, 'width')) - (contentLeftMargin + contentRightMargin),
			carouselHeight: parseInt(Element.getStyle(id_content, 'height')),
			reflectionHeight: 50,
			reflectionTopMargin: 2,
			imgSourceType: 'href',
			imgSource: id_thumbs
		});
		
	}
		
}

//------------------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------------------
// CLASS Builder
//
// build the gallery parts
//------------------------------------------------------------------------------------------------------------------------

Builder = Class.create();

Builder.prototype = {
	
	initialize: function(options) {
		
		var builder = this;
		
		// options
		this.options = options || {};
		this.wrapper = this.options.wrapper;
		this.reflection = this.options.reflection;
		
		// vars
		this.wrapperWidth = parseInt(Element.getStyle(wrapper, 'width'));
		this.wrapperHeight = parseInt(Element.getStyle(wrapper, 'height'));
		
		this.initialized = true;
		
	},
	
	gallery: function() {
		
		// build elements
		
		var objHeader = new Element('div', { id: id_header });
		$(this.wrapper).appendChild(objHeader);
		
		var objContent = new Element('div', { id: id_content });
		$(this.wrapper).appendChild(objContent);
		
		var objFooter = new Element('div', { id: id_footer });
		$(this.wrapper).appendChild(objFooter);
		
		var objTitle = new Element('div', { id: id_title });
		objHeader.appendChild(objTitle);
		
		var objButton = new Element('a', { id: id_button_overview, href: '#' });
		objHeader.appendChild(objButton);
		
		Event.observe(objButton, 'click', new Function('fx', 'myButtons.show_overview()'));
		
		var objLoader = new Element('div', { id: id_loader });
		$(this.wrapper).appendChild(objLoader);
		
		var objLoaderAni = new Element('div', { id: id_loader_ani });
		objLoader.appendChild(objLoaderAni);
		
		// set styles
		this.headerHeight = parseInt(Element.getStyle(id_header, 'height'));
		this.footerHeight = parseInt(Element.getStyle(id_footer, 'height'));
		this.contentHeight = this.wrapperHeight - this.headerHeight - this.footerHeight;
		
		$(id_header).setStyle({
			width: this.wrapperWidth + 'px',
			top: '0px',
			left: '0px'
		});
		
		$(id_content).setStyle({
			width: this.wrapperWidth + 'px',
			height: this.contentHeight + 'px',
			top: this.headerHeight + 'px',
			left: '0px'
		});
		
		$(id_footer).setStyle({
			width: this.wrapperWidth + 'px',
			top: (this.headerHeight + this.contentHeight) + 'px',
			left: '0px'
		});
		
		$(id_button_overview).setStyle({
			display: 'none'
		});
		
		$(id_loader).setStyle({
			width: this.wrapperWidth + 'px',
			height: this.contentHeight + 'px',
			top: this.headerHeight + 'px',
			left: '0px'
		});
		
		// build animations
		buildAnimation_loader();
		
	},
	
	overview: function(xml_file) {
		
		// load xml file
		myXML.load(xml_file);
		
		// call this functions on xml load
		myXML.options.onBuild = function(value) {
			
			// build elements
			
			var objHeadline = new Element('h1', {}).update(value['name'][0]);
			$(id_title).appendChild(objHeadline);
			
			var objButtonSpan = new Element('span', {}).update(value['name'][0]);
			$(id_button_overview).appendChild(objButtonSpan);
			
			var objOverview = new Element('div', { id: id_overview });
			$(id_content).appendChild(objOverview);

			for (var i=0, j=value['id'].length; i<j; i+=1) {
				
				var objSkimmerWrapper = new Element('div', { 'class': class_SkimmerWrapper, id: (class_SkimmerWrapper + '_' + i) });
				objOverview.appendChild(objSkimmerWrapper);
				
				var objSkimmer = new Element('div', { 'class': class_Skimmer, id: (class_Skimmer + '_' + i) }).setStyle({
					backgroundColor: 'transparent',
					background: 'url(images/temp/' + value['id'][i] + '.jpg)',
					backgroundRepeat: 'no-repeat',
					backgroundPosition: 'top left'
				});
				objSkimmerWrapper.appendChild(objSkimmer);
				
				Event.observe(objSkimmer, 'click', new Function('fx', 'myGallery.thumbs("'+contentFolder+''+value['xml'][i]+'", false)'));
				
				var objSkimmerMask = new Element('div', { 'class': class_SkimmerMask });
				objSkimmer.appendChild(objSkimmerMask);
				
				var objSkimmerTitle = new Element('p', { 'class': class_SkimmerTitle }).update(value['title'][i]);
				objSkimmerWrapper.appendChild(objSkimmerTitle);
				
				var objSkimmerCounter = new Element('p', { 'class': class_SkimmerCounter }).update(value['img_count'][i] + ' ' + lang_pictures);
				objSkimmerWrapper.appendChild(objSkimmerCounter);

			}
			
			// calculate margins
			var skimmerWidth = parseInt(Element.getStyle((class_SkimmerWrapper + '_0'), 'width'));
			var skimmerHeight = parseInt(Element.getStyle((class_SkimmerWrapper + '_0'), 'height'));
			var skimmerTopMargin = parseInt(Element.getStyle((class_SkimmerWrapper + '_0'), 'marginTop'));
			var skimmerMinMargin = parseInt(Element.getStyle((class_SkimmerWrapper + '_0'), 'marginLeft'));
			var skimmerFrames = document.getElementsByClassName(class_SkimmerWrapper);
			var skimmerCounter = value['id'].length;
			var skimmerMaxInLine = Math.floor( parseInt(Element.getStyle(id_overview, 'width')) / (skimmerWidth + skimmerMinMargin) );
			var skimmerNewMargin = Math.floor( ( parseInt(Element.getStyle(id_overview, 'width')) - (skimmerMaxInLine * (skimmerWidth + skimmerMinMargin)) - skimmerMinMargin ) / (skimmerMaxInLine + 1) );
				
			// calculate overview height
			var lineCount = Math.ceil(skimmerCounter / skimmerMaxInLine);
			var newOverviewHeight = (lineCount * (skimmerHeight + skimmerTopMargin));
			$(id_overview).setStyle({
				height: newOverviewHeight + 'px'
			});
			
			// init the scrollbar
			myScroller = new contentScroller("gallery_content", "gallery_overview", {
				arrowPosition: setting_scroller_arrow,
				trackPosition: setting_track_position,
				offsetTop: setting_offset_top,
				offsetBottom: setting_offset_bottom,
				contentRightMargin: contentRightMargin,
				contentLeftMargin: contentLeftMargin
			});
			
			// recalculate everything
			skimmerMaxInLine = Math.floor( parseInt(Element.getStyle(id_overview, 'width')) / (skimmerWidth + skimmerMinMargin) );
			skimmerNewMargin = Math.floor( ( parseInt(Element.getStyle(id_overview, 'width')) - (skimmerMaxInLine * (skimmerWidth + skimmerMinMargin)) - skimmerMinMargin ) / (skimmerMaxInLine + 1) );
			lineCount = Math.ceil(skimmerCounter / skimmerMaxInLine);
			newOverviewHeight = (lineCount * (skimmerHeight + skimmerTopMargin));
			$(id_overview).setStyle({
				height: newOverviewHeight + 'px'
			});
			
			// set scrollbar
			myScroller.resizeHandle();
			
			// set the new skimmer margin
			for (var i=0, j=skimmerFrames.length; i<j; i+=1) {
				skimmerFrames[i].style.marginLeft = skimmerMinMargin + skimmerNewMargin +'px';
			}
			
			// init the skimmer function
			mySkimmer = new Control.Skimmer({
				marker: class_Skimmer,
				indicator: true,
				size: 160
			});
			
			// loading screen
			if ($(id_loader).getStyle('display') != 'none') {
				window.aniLoader.seekTo(0);
			}
		}
	},
	
	thumbs: function(xml_file) {
			
		// load xml file
		myXML.load(xml_file);

		// call this functions on xml load
		myXML.options.onBuild = function(value) {
			
			// get dimensions
			this.viewport = document.viewport.getDimensions();
		
			// build elements
			if(!$(id_thumbs)) {
				var objThumbs = new Element('div', { id: id_thumbs });
				$(id_content).appendChild(objThumbs);
			} else {
				clearContent(id_thumbs);
				var objThumbs = $(id_thumbs);
			}
		
			var objList = new Element('ul', { 'class': id_thumbsList });
			objThumbs.appendChild(objList);
		
			// build list elements
			for (var i=0, j=value['title'].length; i<j; i+=1) {
				
				// check if file exists (with javascript)
				// javascript method disabled, because it loads the file				
				// checkObj = new Ajax.Request(contentFolder+'/'+value['file'][i], {
				// 	onSuccess: function(response) {
				// 		checkObj.transport.abort();
				// 	},
				// 	on404: function(response) {
				// 		errorBreak = true;
				// 		errorType = '404';
				// 	},
				// 	onFailure: function(response) {
				// 		errorBreak = true;
				// 		errorType = 'failure';
				// 	}
				// });
				
				// check if file exists (with php)
				checkObj = new Ajax.Request(value['file'][i], {
					onSuccess: function(response) {
						var responseMessage = new Array();
						responseMessage = response.responseText.split('|');
						if (responseMessage[0] == 404) {
							errorBreak = true;
							errorType = '404';
							errorValue = responseMessage[1];
						}
					},
					onFailure: function(response) {
						// 
						// errorBreak = true;
						// errorType = 'failure';
					}
				});
				
				// build
				var objListElement = new Element('li', { 'class': class_thumbsListItem });
				objList.appendChild(objListElement);
				
				var objLink = new Element('a', { 'class': lightbox_marker, href: value['file'][i] + '&width=' + this.viewport['width'] + '&height=' + this.viewport['height'], title: value['title'][i] });
				objLink.onclick = function() {return false;};
				objListElement.appendChild(objLink);
				
				var objThumb = new Element('img', { 'class': class_thumbsImage, src: value['file'][i] + '&width=' + thumbsMaxWidth + '&height=' + thumbsMaxHeight + '&sWidth=' + skimmerMaxWidth + '&sHeight=' + skimmerMaxHeight + '&rHeight=' + reflectionHeight + '&color=' + reflectionColor + '&sAlpha=' + reflectionStartAlpha + '&eAlpha=' + reflectionEndAlpha + '&output=img' });
				objLink.appendChild(objThumb);

				if (myBuilder.reflection === true) {
					var objReflection = new Element('img', { 'class': class_thumbsReflection, src: value['file'][i] + '&width=' + thumbsMaxWidth + '&height=' + thumbsMaxHeight + '&sWidth=' + skimmerMaxWidth + '&sHeight=' + skimmerMaxHeight + '&rHeight=' + reflectionHeight + '&color=' + reflectionColor + '&sAlpha=' + reflectionStartAlpha + '&eAlpha=' + reflectionEndAlpha + '&output=refl' });
					objListElement.appendChild(objReflection);
				}

				var objTitle = new Element('div', { 'class': class_thumbsTitle });
				objListElement.appendChild(objTitle);
				
				var objTitleSpan = new Element('span', {}).update(value['title'][i]);
				objTitle.appendChild(objTitleSpan);
		
			}
			
			// recall
			myGallery.thumbs('', true);
			
		}
	}
	
}

//------------------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------------------
// CLASS CONTROL BUTTONS
//
// controls the navigation buttons
//------------------------------------------------------------------------------------------------------------------------

if(!Control) var Control = {};
Control.Buttons = Class.create();

Control.Buttons.prototype = {
	
	initialize: function(target, options) {
		
		var buttons = this;
		
		// options
		this.options = options || {};
		
		this.showThumbs = this.options.showThumbs;
		this.showMosaic = this.options.showMosaic;
		this.showCarousel = this.options.showCarousel;
		this.id_buttonWrapper = this.options.idButtons;
		this.id_thumbs = this.options.idThumbs;
		this.id_mosaic = this.options.idMosaic;
		this.id_carousel = this.options.idCarousel;
		
		this.target = $(target);
		
		// create DOM nodes
		if(!$(this.id_buttonWrapper)) {			
			var objButtons = document.createElement('div');
			objButtons.setAttribute('id', this.id_buttonWrapper);
			objButtons.style.display = 'none';
			this.target.appendChild(objButtons);
			
			if (this.showThumbs === true) {
				var objButtonThumbs = document.createElement('div');
				objButtonThumbs.setAttribute('id', this.id_thumbs);
				objButtons.appendChild(objButtonThumbs);
				
				Event.observe($(this.id_thumbs), 'click', this.show_thumbOverview.bindAsEventListener(this));
			}
			
			if (this.showMosaic === true) {
				var objButtonMosaic = document.createElement('div');
				objButtonMosaic.setAttribute('id', this.id_mosaic);
				objButtons.appendChild(objButtonMosaic);
				
				Event.observe($(this.id_mosaic), 'click', this.show_mosaicOverview.bindAsEventListener(this));
				
			}
			
			if (this.showCarousel === true) {
				var objButtonCarousel = document.createElement('div');
				objButtonCarousel.setAttribute('id', this.id_carousel);
				objButtons.appendChild(objButtonCarousel);
				
				Event.observe($(this.id_carousel), 'click', this.show_carouselOverview.bindAsEventListener(this));
			}
		}
		
		this.initialized = true;
		
		this.draw();
	},
	
	show_thumbOverview: function(e) {
		if (Element.getStyle(id_thumbs, 'display') != 'block') {
			window.aniLoader.seekTo(1);
			setTimeout(function() {switchView(id_thumbs);}, 500);
		}
	},
	
	show_mosaicOverview: function(e) {
		alert('switch to mosaic');
	},
	
	show_carouselOverview: function(e) {
		window.aniLoader.seekTo(1);
		setTimeout(function() {switchView(id_carousel);}, 500);
	},
	
	show_overview: function(e) {
		window.aniLoader.seekTo(1);
		setTimeout(function() {switchView(id_overview);}, 500);
	},
	
	draw: function() {
		$(this.id_buttonWrapper).setStyle({
			display: 'block'
		});
	}
	
}

//------------------------------------------------------------------------------------------------------------------------





//------------------------------------------------------------------------------------------------------------------------
// ANIMATIONS
//
// some more basic animations
//------------------------------------------------------------------------------------------------------------------------

// animation of overlay layer

function buildAnimation_loader() {
	if (typeof window.aniLoader == 'undefined') {
		window.aniLoader = new Animator({
			duration: 500
		}).addSubject(new NumericalStyleSubject(
		    $(id_loader), 'opacity', 0, 1)
		).addSubject(updateAnimation_loader);
	}
}

function updateAnimation_loader(value) {
	if(value == 0) {
		$(id_loader).setStyle({
			display: 'none'
		});
	} else {
		$(id_loader).setStyle({
			display: 'block'
		});
	}
}

// switch visibilty of gallery elements

function switchView(element) {
	
	if(element == id_thumbs) {
		
		$(id_overview, id_title).invoke('hide');
		$(id_thumbs, id_slider, id_button_overview, id_buttons).invoke('show');
		
		if ($(id_carousel)) {
			$(id_carousel).setStyle({
				display: 'none'
			});
		}
		
		if($('scroller_track')) {
			myScroller.setContent(id_thumbs);
		}
		
		window.aniLoader.seekTo(0);
		
	} else if(element == id_carousel) {
		
		myGallery.carousel();
		
		$(id_overview, id_thumbs, id_slider, id_title).invoke('hide');
		$(id_carousel, id_button_overview, id_buttons).invoke('show');
		
		if($('scroller_track')) {
			myScroller.setContent(id_carousel);
		}
		
		window.aniLoader.seekTo(0);
		
	} else if(element == id_overview) {
		
		$(id_thumbs, id_slider, id_button_overview, id_buttons).invoke('hide');
		$(id_overview, id_title).invoke('show');
		
		if ($(id_carousel)) {
			$(id_carousel).setStyle({
				display: 'none'
			});
		}
		
		if($('scroller_track')) {
			myScroller.setContent(id_overview);
		}
		
		window.aniLoader.seekTo(0);
		
	}
	
}
