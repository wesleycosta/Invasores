-- Bibliotecas
require("drawable");

--Variaveis
AreaX = 0             AreaY = 0 i = 0     GameOver = false      Comecou = false
ContAlien = 0         NumInvaders = 19    VelAliens = 6         VelLaserAliens = 10
Eliminados = 0        MaxTiro = 20 
Invaders = {}         LazerNave = {}      LazerInvaders = {}    Estrelas = {}   energia = {}
Tempo = 0             NumTropas = 0       Pontos = 0

-- Funções Principais
-- LOAD
function love.load()
    love.graphics.setFont(Fonts.Grande)
    AjustaTela()
    math.randomseed( os.time() )    
    intro = love.audio.newSource("sound/fundo.ogg", "static")
    SomLaser = love.audio.newSource("sound/laser.ogg", "static")
    SomExplosao = love.audio.newSource("sound/explosion.ogg", "static")
    intro:setLooping(true)
    love.audio.play(intro)
    
    -- mouse
        pointer = {image=love.graphics.newImage("img/pointer.png"), width, height}
        pointer.width = pointer.image:getWidth()
        pointer.height = pointer.image:getHeight()
   
    -- caregar imagens
        explosao  = {img = drawable.newDrawable("img/Bomb.png", -100 , -100), config={}}
        nave  = {img = drawable.newDrawable("img/nave.png", AreaX/2 + 8 , AreaY - 10), config={}}
        NovoJogo = {img = drawable.newDrawable("img/NovoJogo.png", AreaX / 2 - 35, AreaY / 2 + 200), config = {}}
        Sair = {img = drawable.newDrawable("img/Sair.png",  AreaX / 2 - 35, AreaY / 2 + 250), config = {}}
        
        for w = 0, MaxTiro - 1 do
            energia[w] = {img = drawable.newDrawable("img/energia.png", (AreaX + 65) - (w*7), AreaY + 40), config={}}
        end
        
        for z= 0, 200 do
            Estrelas[z] = {img = drawable.newDrawable("img/star.png", math.random (0,AreaX + 100), math.random (0, AreaY + 100)), config = {}}
        end
       
        
        for j = 0, NumInvaders do
            Invaders[j] =  {img = drawable.newDrawable("img/invaders.png", math.random (15, AreaX - 80), -250 * j),config = {}}
            LazerInvaders[j] = {img = drawable.newDrawable("img/laser2.png",100,0),config = {}}
        end
        
        for j = 0, MaxTiro - 1 do
            LazerNave[j] =  {img = drawable.newDrawable("img/laser.png",-20,-20),config = {}}
        end
    -- fim carrega imagens
end

--DRAW
function love.draw()
    DrawEstrelas()
    draw(nave.img)
    --Desenha a nave
   if(Comecou) then
       if(GameOver) then
            
            draw(explosao.img)
            love.graphics.setFont(Fonts.Grande)
            love.graphics.print("[GAME OVER]", AreaX/2 - 300, AreaY/2 - 100)
            draw(Sair.img) 
            draw(NovoJogo.img)  
            love.graphics.draw(pointer.image, love.mouse.getX(), love.mouse.getY(), 0, 1, 1, pointer.width/2, pointer.height/2)
       else
            DrawPente()
            TiroAcertouNave()
            TiroAcertouInvaders()
            love.graphics.print("PONTOS: " .. string.format("%d", Pontos), 15, AreaY + 40)
           
            DesenhaInvaders() --Desenha invasores
            DesenhaLaserInvaders()
            if( i <= MaxTiro) then
               DesenhaTirosNave() --Desenha os tiros da nave
            end
          
        end
    else
        Cronometro()
    end
end

--UPDATE
function love.update()
    if(Comecou) then
        Bateu()
        MoveNave() -- Função pra mover os aliens
    else
        Tempo = Tempo + 1
        if(Tempo >= 100) then
            Tempo = 0
            Comecou = true
            love.graphics.setFont(Fonts.Pequeno)
        end
    end
    if(GameOver) then
         PX = love.mouse.getX()
         PY = love.mouse.getY()
        if (love.mouse.isDown(1)) then
            if(PX >= NovoJogo.img.x + 30 and PX <= NovoJogo.img.x + 115 and PY >= NovoJogo.img.y  and PY <= NovoJogo.img.y + 30 )then
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
end
-- Fim Funções Principais

-- cronometro -> 3, 2, 1 , GO
function Cronometro()
    if(Tempo >= 0 and Tempo <= 25) then
         love.graphics.print("3",              AreaX/2 + 6,     AreaY/2 - 60)
    elseif(Tempo > 25 and Tempo <= 50) then
        love.graphics.print("2",               AreaX/2 + 6,     AreaY/2 - 60)
        elseif(Tempo > 50 and Tempo <= 75) then
        love.graphics.print("1",               AreaX/2 + 12,    AreaY/2 - 60)
        elseif(Tempo > 75 and Tempo <= 100) then
         love.graphics.print("GO",             AreaX/2 - 26,    AreaY/2 - 60)
    end
end

-- Desenha os invaders na tela
function DesenhaInvaders()
   if(not GameOver) then
       for z = 0, NumInvaders do
             draw(Invaders[z].img) -- Desenha os invarores na tela
             Invaders[z].img.y = Invaders[z].img.y + VelAliens -- move o alien 3px para baixo
             if(Invaders[z].img.y > AreaY / 2 - 300 and z >= ContAlien) then -- Dispara os tiros dos Aliens
                 LazerInvaders[z].img.y = Invaders[z].img.y + 45 -- Posiciona tiro aliens no eixo Y
                 LazerInvaders[z].img.x = Invaders[z].img.x + 22 -- Posiciona tiro aliens no eixo X
                 draw(LazerInvaders[z].img) -- Desenha o tiro dos aliens
                 ContAlien = ContAlien + 1  -- var pra controlar qual alien vai atirar
                 TiroAcertouNave()
             end
        end
        local temp = 0
        for j = 0, NumInvaders do
          if(Invaders[j].img.y < AreaY + 80) then -- Verifica se os aliens ja sairam da tela ou foi eliminado
                temp = temp + 1
          end
        end
        if(temp == 0) then
            for z = 0, NumInvaders do
                Invaders[z].img.x = math.random (35, AreaX - 70) -- Sorteia posição
                Invaders[z].img.y = (-200 * z)
            end
            ContAlien = 0
            NumTropas = NumTropas + 1
            VelLaserAliens = VelLaserAliens + 1
            VelAliens = VelAliens + 1
        end
     end
end

function DesenhaLaserInvaders()
     for j = 0, ContAlien - 1 do
         LazerInvaders[j].img.y = LazerInvaders[j].img.y + VelLaserAliens -- move o tiro dos invasores 5px para baixo
        draw(LazerInvaders[j].img) -- Desenha os tiros dos invasores
     end
end

-- função que desenha quantos tiros a no pente!
function DrawPente()
    for j =0,  (MaxTiro - 1) - i do
        draw(energia[j].img)
    end
    tempValor = MaxTiro - i;
    if(tempValor == 0) then
        love.graphics.print("CARREGANDO", AreaX - 40, AreaY + 10) 
    else
         love.graphics.print(" " .. string.format("%.2d",tempValor) .. "/20", AreaX + 14 , AreaY + 18) 
    end
end

-- Verifica se o tiro do alien acertou os invaders
function TiroAcertouInvaders()
    for z = 0, 19  do
      for w = 0, NumInvaders do
       if(LazerNave[z].img.x >=Invaders[w].img.x and LazerNave[z].img.x <=Invaders[w].img.x + 60 and LazerNave[z].img.y -60 <=Invaders[w].img.y and LazerNave[z].img.y >=Invaders[w].img.y and  Invaders[w].img.y >= 10) then
             LazerNave[z].img.y = -20
             LazerNave[z].img.x = -20
             Invaders[w].img.y =  AreaY + 80
             Invaders[w].img.x =  0
             Eliminados = Eliminados + 1
             Pontos = Pontos + 10 + (Eliminados * 100 / (i * 40))
          end
        end
    end
end

function Bateu()
       for j = 0, NumInvaders do
           if((nave.img.y >= Invaders[j].img.y - 60 and nave.img.y <= Invaders[j].img.y + 55) and (nave.img.x >= Invaders[j].img.x - 60 and nave.img.x <= Invaders[j].img.x + 35)) then
                GameOver = true
                explosao.img.x, explosao.img.y = nave.img.x, nave.img.y
                nave.img.x, nave.img.y = -100, -20 * j
                draw(explosao.img)
                love.audio.play(SomExplosao)
            end
       end
end
-- Verifica se o tiro do alien acertou a nave
function TiroAcertouNave()
       for w = 0, NumInvaders do
           if(LazerInvaders[w].img.y  >= nave.img.y and LazerInvaders[w].img.y <= nave.img.y + 60  and LazerInvaders[w].img.x >= nave.img.x and LazerInvaders[w].img.x <= nave.img.x + 60) then
                GameOver = true
                explosao.img.x, explosao.img.y = nave.img.x, nave.img.y
                nave.img.x, nave.img.y = -100, -20 * w
                draw(explosao.img)
                love.audio.play(SomExplosao)
          end
       end
end

--Desenha os tiros da nave
function DesenhaTirosNave()
  for j = 0, i - 1 do
    draw(LazerNave[j].img)
    TiroAcertouInvaders()
    LazerNave[j].img.y =LazerNave[j].img.y - 8
  end
  if(LazerNave[MaxTiro - 1].img.y < 0) then
      for j = 0, MaxTiro -1 do
      LazerNave[j].img.y = 0
    end
     i = 0
  end
end

-- Dispara tiros da nave
function DisparaTiro()
  if( i < MaxTiro) then
      LazerNave[i].img.x = nave.img.x + 25
  LazerNave[i].img.y = nave.img.y - 26
    DesenhaTirosNave()
    i = i + 1
   end
end

--Desenha um objeto drawable na tela
function draw(Fig)
     love.graphics.draw(Fig.img, Fig.quad, Fig.x, Fig.y) --draw desenha um objeto do tipo quad
end

-- Desenha estrelas
function DrawEstrelas()
    for z= 0, 200 do
        if(not GameOver) then 
            Estrelas[z].img.y = Estrelas[z].img.y + 2
        end
        if(Estrelas[z].img.y  >= AreaY + 50) then
            Estrelas[z].img.x, Estrelas[z].img.y = math.random (0, AreaX + 100), -z * math.random (1, 4)
        end
        draw(Estrelas[z].img)   
    end
end

-- Coloca em tela cheia e pega o valor de X e Y da tela
function AjustaTela()
  love.graphics.setBackgroundColor(10,10,10)
  love.mouse.setVisible(false)
  love.window.setFullscreen(true, "desktop")
  AreaX = love.graphics.getWidth( )- 80
  AreaY = love.graphics.getHeight() - 70
end

-- Evento keypress
function love.keypressed(key)
   if (key == "space" and Comecou) then
      DisparaTiro()
   end
   if(key == "escape" or key == "q") then
        love.audio.stop()
        love.filesystem.load('main.lua')()
        love.load()
   end
   if(key == "n") then
       love.audio.stop()
        love.filesystem.load('game.lua')()
        love.load()
    end
end

-- Mover a Nave
function MoveNave()
  if(not GameOver) then
      --Tratamento de movimento da nave
      --Mover Horizontalmente
      if (love.keyboard.isDown("left") or love.keyboard.isDown("a")) then
          nave.img.x = nave.img.x - 5
      end
      if (love.keyboard.isDown("right") or love.keyboard.isDown("d")) then
          nave.img.x = nave.img.x + 5
      end

      -- Mover Verticalmente
      if (love.keyboard.isDown("up") or love.keyboard.isDown("w")) then
          nave.img.y = nave.img.y - 4
      end
      if (love.keyboard.isDown("down") or love.keyboard.isDown("s")) then
          nave.img.y = nave.img.y + 4
      end

      --Inicio de verificaao de limites
      -- Eixo X
      if (nave.img.x  > AreaX + 12) then
          nave.img.x = AreaX + 12
        end
        if (nave.img.x < 5) then
            nave.img.x = 5
        end
      -- fim X

      -- Eixo Y
        if (nave.img.y > AreaY) then
          nave.img.y = AreaY
        end
        if (nave.img.y < 3) then
            nave.img.y = 3
        end
    end
end