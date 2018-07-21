-- Bibliotecas
require("drawable");

Estrelas = {}
PX = 0 PY = 0

-- Funções Principais
-- LOAD
function love.load()

    AjustaTela()
    intro = love.audio.newSource("sound/intro.ogg", "stream")
    SomLaser = love.audio.newSource("sound/laser.ogg", "stream")
    intro:setLooping(true)
    love.audio.play(intro)
   
    Jogar = {img = drawable.newDrawable("img/jogar.png", AreaX / 2 - 35, AreaY / 2 + 200), config = {}}
    Creditos = {img = drawable.newDrawable("img/Creditos.png", AreaX / 2 - 35, AreaY / 2 + 250), config = {}}
    Sair = {img = drawable.newDrawable("img/Sair.png", AreaX / 2 - 35, AreaY / 2 + 300), config = {}}
    
    pointer = {image=love.graphics.newImage("img/pointer.png"), width, height}
    pointer.width = pointer.image:getWidth()
    pointer.height = pointer.image:getHeight()
    
    Fonts = {
        Grande =  love.graphics.newFont("fonts/RailwayToHells.ttf", 70),
        Pequeno =  love.graphics.newFont("fonts/RailwayToHells.ttf", 11),
        Medio =  love.graphics.newFont("fonts/RailwayToHells.ttf", 30) 
    }
        
    for z= 0, 200 do
        Estrelas[z] = {img = drawable.newDrawable("img/star.png", math.random (0,AreaX + 100), math.random (0, AreaY + 100)), config = {}}
    end

end

--DRAW
function love.draw()
    DrawEstrelas()  
    
    --love.graphics.setFont(Fonts.Medio)
    --love.graphics.print("mouse x = " ..PX, 10, 50)
    --love.graphics.print("mouse y = " ..PY, 10, 100)
    --love.graphics.print(" jogarx = " ..Jogar.img.x, 10, 150)
    --love.graphics.print(" jogary = " ..Jogar.img.y, 10, 200)

    love.graphics.setFont(Fonts.Grande)
    love.graphics.print("[INVADERS]", AreaX / 2 - 270, AreaY / 2 - 220)
    love.graphics.setFont(Fonts.Pequeno)
    draw(Jogar.img)  
    draw(Creditos.img)  
    draw(Sair.img)  
    love.graphics.draw(pointer.image, love.mouse.getX(), love.mouse.getY(), 0, 1, 1, pointer.width/2, pointer.height/2)
end

--UPDATE
function love.update()
    PX = love.mouse.getX()
    PY = love.mouse.getY()
    
    if (love.mouse.isDown(1)) then
        if(PX >= Jogar.img.x + 30 and PX <= Jogar.img.x + 115 and PY >= Jogar.img.y  and PY <= Jogar.img.y + 30 )then
            love.audio.stop()
            love.filesystem.load('game.lua')()
            love.load()
        end
        if(PX >= Sair.img.x + 45  and PX <= Sair.img.x + 100 and PY >= Sair.img.y  and PY <= Sair.img.y + 30 )then
            love.audio.stop()
            love.event.quit()
        end
    end
end
-- Fim Funções Principais

function DrawEstrelas()
    for z= 0, 200 do         
        draw(Estrelas[z].img)   
    end
end

--Desenha um objeto drawable na tela
function draw(Fig)
     love.graphics.draw(Fig.img, Fig.quad, Fig.x, Fig.y) --draw desenha um objeto do tipo quad
end

-- Coloca em tela cheia e pega o valor de X e Y da tela
function AjustaTela()
  love.mouse.setVisible(false)
  love.graphics.setBackgroundColor(10,10,10)
  love.window.setFullscreen(true, "desktop")
  AreaX = love.graphics.getWidth( ) - 80
  AreaY = love.graphics.getHeight() - 70
end

-- Evento keypress
function love.keypressed(key)
   if (key == "escape"  or key == "q") then
      love.event.quit()
   end
end

