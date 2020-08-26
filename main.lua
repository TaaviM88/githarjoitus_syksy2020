function love.load()
	leveys = 20
	korkeus = 15
	--säädetään ikkunan resoluutio kohdilleen
	love.window.setMode(leveys*15,korkeus*15)
	--love.graphics.setBackgroundColor(0.5,0.8,1,1)

	reset()
end

function reset()

	mato ={
	{x = 3, y =1},
	{x = 2, y = 1},
	{x = 1, y = 1},
	}
	suunta = 'right'
	ajastin = 0
	aikaraja = 0.15
	--pisteet mitä voidaan kerryttää aina kun syödään
	pisteet = -1
	ruoki()
end

function  ruoki()
	ruoka = {}
	ruokaX = love.math.random(1,leveys)
	ruokaY = love.math.random(1,korkeus)
	
	ruoka.x =ruokaX
	ruoka.y = ruokaY
	--annetaan piste
	pisteet = pisteet + 1

end


function love.update(dt)
	ajastin = ajastin + dt

	if ajastin >= aikaraja then
		ajastin = ajastin - aikaraja
		local seuraavaX = mato[1].x
		local seuraavaY = mato[1].y
		
		peliJatkuu = true
		
		if suunta == 'right' then
			seuraavaX = seuraavaX + 1
			if seuraavaX > leveys then
				peliJatkuu = false;
			end
			
		elseif suunta == 'left'then
		seuraavaX = seuraavaX - 1
			if seuraavaX < 1 then
				peliJatkuu = false
			end
		elseif suunta == 'down' then
			seuraavaY = seuraavaY +1
			if seuraavaY > korkeus then
				peliJatkuu = false
			end
		elseif suunta == 'up' then
			seuraavaY = seuraavaY - 1
			if seuraavaY < 1 then
				peliJatkuu  = false
			end
		end
		
		for indeksi, matopala in ipairs(mato) do
			if indeksi ~= #mato and seuraavaX == matopala.x and seuraavaY == matopala.y then
			peliJatkuu = false
			end
		end
		
		if peliJatkuu then
		table.insert(mato, 1,{x = seuraavaX, y = seuraavaY})
		
			if mato[1].x == ruoka.x and mato[1].y == ruoka.y then
				ruoki()
				-- nopeutetaan matoa jokaisella syödyllä ruualla
				aikaraja = aikaraja - 0.1
				
				if aikaraja < 0.1 then
					aikaraja = 0.1
					
				end
				
			else
				table.remove(mato)
			end
		end
	end
end

function love.draw()
	local ruutu = 15
	
	love.graphics.setColor(.28, .28, .28)
	love.graphics.rectangle('fill',0,0,leveys * ruutu,korkeus*ruutu)
	
	local function piirraRuutu(x,y)
	love.graphics.rectangle('fill',(x-1) * ruutu,(y -1)* ruutu, ruutu -1, ruutu -1)
	end
	
	love.graphics.setColor(1,.3,.3)
	piirraRuutu(ruoka.x, ruoka.y)
	
	for indeksi, matopala in  ipairs(mato) do
		love.graphics.setColor(0.6, 0.9, .32)
		piirraRuutu(matopala.x, matopala.y)
	end
	--näytetään pisteet
	love.graphics.print(pisteet, (leveys-1)*ruutu ,0)
	-- jos peli ei jatku niin piirretään keskelle ruutua teksti missä lukee game over ja pistemäärä ja ohjeet miten aloittaa alusta
	if peliJatkuu == false then
		love.graphics.setColor(1,0,0.25)
		gameoverText = "Game Over points: " .. tostring(pisteet) .. "\nPress enter to start over" 
		love.graphics.print(gameoverText, (leveys /2 * ruutu)/2, (korkeus*ruutu)/2)
	end
	
end

function love.keypressed(key)
	if(key == 'right' and peliJatkuu and suunta ~='left') then
	suunta = 'right'
	elseif key == 'left' and peliJatkuu and suunta ~= 'right' then
	suunta = 'left'
	elseif key == 'up' and peliJatkuu and suunta ~= 'down' then
	suunta = 'up'
	elseif key == 'down' and peliJatkuu and suunta ~= 'up' then
	suunta = 'down'
	elseif key == 'return' then
	reset()
	end
end
