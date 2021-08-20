---
layout: page
title: Blog
permalink: /blog/
nav_order: 5
---

# Blog

<ul class="blog">
  {% for post in site.posts %}
    <li>
      <div class="header">
         <h4>{{ post.date | date_to_string }}</h4>
         <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
      </div>
      {{ post.excerpt }}
    </li>
  {% endfor %}
</ul>
