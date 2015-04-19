package commands;

import flash.display.Sprite;

class ShootCommand extends Command {

	private var success:Bool = false;
	private var hit:Bool = false;
	private var critical:Bool = false;
	private var hitCover:Bool = false;
	
	public function new(subject, target, battle){
		super(subject, target, battle);
	}

	public override function perform(){
		super.perform();
		if(subject.inCover && subject.getFrame() < 516)
			subject.gotoAndPlay(516);
		else if(subject.inCover)
			subject.gotoAndPlay(532);
		else
			subject.gotoAndPlay(132);

		subject.shooting = true;

		success = Math.random()>.05;
		hit = Math.random()>.2;
		critical = Math.random()>.8;

		if(subject.bullets == 0){
			Main.transcript += SentenceParser.chooseRandom([
				" Click. He's out of ammo.",
				" He realises there are no bullets in his gun."
			]);
			success = false;
			return;
		}

		if(subject.jammed){
			Main.transcript += SentenceParser.chooseRandom([
				" His gun is still jammed, he cannot use it."
			]);
			success = false;
			return;
		}

		if(target.inCover && target.shooting) hit = Math.random()>.6;
		else if(target.inCover) hit = false;

		if(target.inCover && !hit){
			Main.transcript += SentenceParser.chooseRandom([
				" The bullet is stopped short by "+SentenceParser.possessive(target.lastName)+" cover.",
				" The bullet hits the cover in front of him."
			]);
			hitCover = true;
			subject.bullets--;
			return;
		}

		if(success){
			if(hit){
				target.takeDamage(2+Math.random()*2 + (critical?3:0));
				if(target.alive){
					Main.transcript += SentenceParser.chooseRandom([
						" Direct hit.",
						" The bullet hits its mark.",
						" "+target.lastName+" takes a hard hit."
					]);
					if(critical) Main.transcript += " It hits critically.";
				}
				else
					Main.transcript += SentenceParser.chooseRandom([
						" A deadly blow.",
						" The soldier collapses, dead.",
						" Death comes swiftly to the recipient.",
						" "+SentenceParser.possessive(target.lastName)+" life ends abruptly."
					]);
			}else{
				Main.transcript += SentenceParser.chooseRandom([
					" The bullet whizzes past him.",
					" The bullet narrowly misses.",
					" A near miss."
				]);
			}
			subject.bullets--;
		}
		else {
			subject.jammed = true;
			Main.transcript += SentenceParser.chooseRandom([
				" His gun jams and he is unable to shoot.",
				" Something is blocking the barrel of his gun.",
				" However, the gun's inner workings malfunction, and he is unable to do so."
			]);
		}
	}

	public override function drawEffects(){
		super.drawEffects();
		if(!success) return;

		var trail = new Sprite();

		trail.graphics.lineStyle(2, 0xffffff);
		trail.graphics.moveTo(subject.x - 30 + subject.alignment*100 + (subject.inCover?-8:0), subject.y - 5 + (subject.inCover?15:0));

		if(hitCover){
			trail.graphics.lineTo(target.x-80+160*target.alignment, target.y+20);
			ParticleEngine.bulletHit(target.x-80+160*target.alignment, target.y, target.alignment>0?-1:1);
		}
		else if(hit)
			trail.graphics.lineTo(target.x+15-5*target.alignment, target.y);
		else
			trail.graphics.lineTo(target.x+100-200*target.alignment, target.y+Math.random()*200-100);

		battle.addBulletTrail(trail);

		if(!hit || hitCover) return;

		ParticleEngine.bloodSpray(target.x+15, target.y, target.alignment>0?-1:1);
		for(i in 0...5)
			battle.addBloodPuddle(new BloodPuddle(target.x+30 + Math.random()*20-10, target.y+60 + Math.random()*20-10, Std.int(5+Math.random()*10)));

		if(target.alive) target.gotoAndPlay(156);
		else{
			target.gotoAndPlay(209);
			for(i in 0...5)
				battle.addBloodPuddle(new BloodPuddle(target.x+30 + Math.random()*20-10 - 50 + 100*target.alignment, target.y+60 + Math.random()*20-10, Std.int(10+Math.random()*10), 25));
		}
	}
}