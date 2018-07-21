drawable={
    newDrawable = function (caminho, x, y)
    --  image = love.graphics.newImage("rsc/nave.png")
    --  quad = love.graphics.newQuad(0, 0, image:getWidth(), image:getHeight(), image:getWidth(), image:getHeight())
        
        local Fig = {}
        img = love.graphics.newImage(caminho) -- caminho da imagem
        quad= love.graphics.newQuad(0, 0, img:getWidth(), img:getHeight(),img:getWidth(), img:getHeight())
        Fig["img"]=img
        Fig["quad"]=quad
        Fig["x"]=x
        Fig["y"]=y
        Fig["width"] = img:getWidth()
        Fig["height"] = img:getHeight()
        return Fig
    end
}
