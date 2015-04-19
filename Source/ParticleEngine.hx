package;

class ParticleEngine {

	private static var particles:Array<Particle> = new Array<Particle>();
	
	public static function draw(){

		for(particle in particles){
			particle.update();
			particle.draw();
			if(particle.remove)
				particles.remove(particle);
		}
	}

	public static function bloodSpray(x, y, dir){
		for(i in 0...60)
			particles.push(new Particle(x, y, Math.random()*2*dir, Math.random()*5-2.5, 0.5+Math.random()*4, -0.1+Math.random()*-0.2));
	}
}