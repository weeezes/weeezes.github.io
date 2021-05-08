---
title: Frameworkless calendar component
---

I wanted to learn TypeScript but quickly realized I did not want to learn one of the frontend frameworks at the same time. I wanted to specifically learn to write TypeScript, not React+TypeScript or Vue+TypeScript, because I am lazy. I still needed something more than just a Hello World. I’m absolutely illiterate when it comes to web development.

Minimal example, the click-counter example:

<p class="codepen" data-height="265" data-theme-id="light" data-default-tab="js,result" data-user="weeezes" data-slug-hash="vYgoKqW" data-preview="true" style="height: 265px; box-sizing: border-box; display: flex; align-items: center; justify-content: center; border: 2px solid; margin: 1em 0; padding: 1em;" data-pen-title="Frameworkless-click">
  <span>See the Pen <a href="https://codepen.io/weeezes/pen/vYgoKqW">
  Frameworkless-click</a> by Vesa (<a href="https://codepen.io/weeezes">@weeezes</a>)
  on <a href="https://codepen.io">CodePen</a>.</span>
</p>
<script async src="https://cpwebassets.codepen.io/assets/embed/ei.js"></script>

I found this [Proxy](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) object definition that seemed particularly useful for data bandings. The handler object lets us trigger rendering whenever values change. This is what the whole idea is based on.

The `Component` interface describes an object that has a state, some subscribers that listen to events, a handler that expresses how state changes will be handled and a method for rendering the component in the DOM.

The `Event` interface is trivial, but the [type variable](https://www.typescriptlang.org/docs/handbook/2/generics.html) `K` is important in binding together the types of events the `Component` type can emit, and what other `Components` subscribe to, while keeping things properly type checked. This was a good dive into many of the features of TypeScript.

The example uses [literal types](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#literal-types) to describe the different kinds of events, in this case the only event is `"Clicked"`. This way you cannot accidentally use an unknown type of event without the compiler letting you know. That’s fun and powerful compared to using plain strings.

The subscribers field contains an object with keys being the different values for the event kinds. This uses another interesting feature called [mapped types](https://www.typescriptlang.org/docs/handbook/advanced-types.html#mapped-types), which allows us to create new object types based on arbitrary keys, in this case our `ClickEventKinds` literal type. It resembles another feature called [index types and index signatures](https://www.typescriptlang.org/docs/handbook/advanced-types.html#index-types), but mapped types constrain the available properties to the ones in the provided list. The actual events are created as what is called a [tagged union type](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-0.html#tagged-union-types) and the event objects can be matched by the their `kind`.

The [TypeScript: Handbook](https://www.typescriptlang.org/docs/handbook/intro.html) is an extremely helpful resource.

As a more complex example I built a calendar component where you can look at different months and select dates: [weeezes/frameworkless-calendar](https://github.com/weeezes/frameworkless-calendar)

The amount of boilerplate might look a bit excessive, but what I like about this is that it is all there laid out without dependencies. You could start hiding some of the junk and end up with your own framework, that could be a fun experiment.

It is relatively simple and probably will work for me for quite long, as I am not planning on writing any extremely complex web apps. I feel like this was a genuinely nice learning experience!
