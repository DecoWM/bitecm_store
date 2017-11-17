@if ($paginator->hasPages())
    <ul class="pagination">
        {{-- Previous Page Link --}}
        @if ($paginator->onFirstPage())
            <li class="disabled">
              <span>
                <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
              </span>
            </li>
        @else
            <li><a href="{{ $paginator->previousPageUrl() }}" rel="prev"><span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span></a></li>
        @endif

        {{-- Pagination Elements --}}
        @foreach ($elements as $element)
            {{-- "Three Dots" Separator --}}
            @if (is_string($element))
                <li class="disabled"><span>{{ $element }}</span></li>
            @endif

            {{-- Array Of Links --}}
            @if (is_array($element))
                @foreach ($element as $page => $url)
                    @if ($page == $paginator->currentPage())
                        <li class="active"><span>{{ $page }}</span></li>
                    @else
                        <li><a href="{{ $url }}">{{ $page }}</a></li>
                    @endif
                @endforeach
            @endif
        @endforeach

        {{-- Next Page Link --}}
        @if ($paginator->hasMorePages())
            <li><a href="{{ $paginator->nextPageUrl() }}" rel="next"><span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span></a></li>
        @else
            <li class="disabled">
              <span>
                <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
              </span>
            </li>
        @endif
    </ul>
@endif
