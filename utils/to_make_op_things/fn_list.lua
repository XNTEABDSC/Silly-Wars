local to_make_op_things=GG.to_make_op_things
to_make_op_things.fn_list={}
---add a function, at domain, with key
---
---multiple add with same key makes overlap
---
---order of fn to be called are stored when key assigned
---
---notes fn may needs to use lowerkeys 
---@param domain string
---@param key string
---@param fn function
function to_make_op_things.add_fn_to_fn_list(domain,key,fn)
    if domain=="now" then
        fn()
        return
    end
    if not to_make_op_things.fn_list[domain] then
        to_make_op_things.fn_list[domain]={}
        to_make_op_things.fn_list[domain].order={}
    end
    local l=to_make_op_things.fn_list[domain]
    if not l[key] then
        l.order[#l.order+1]=key
    end
    l[key]=fn
end
---call all fns in domain
---@param domain string
function to_make_op_things.do_fn_list_fns(domain)
    if to_make_op_things.fn_list[domain] then
        local l=to_make_op_things.fn_list[domain]
        for _, key  in pairs(l.order) do
            l[key]()
        end
    end
end
---copy all fns from domainfrom to domainto, by add_fn_to_fn_list
---@param domainfrom string
---@param domainto string
function to_make_op_things.copy_fn_lists(domainfrom,domainto)
    local l=to_make_op_things.fn_list
    if l[domainfrom] then
        local lf=l[domainfrom]
        for _, key  in pairs(lf.order) do
            to_make_op_things.add_fn_to_fn_list(domainto,key,lf[key])
        end
        --[=[
        if not l[domainto] then
            l[domainto]={}
        end
        local lt=l[domainto]
        ]=]
    end
end